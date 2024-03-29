//
//  ViewController.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/15.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import UIKit
import WebKit
import SideMenu
import CKCircleMenuView
import Presentr

class WebViewController: UIViewController {
    let presenter = Presentr(presentationType: .alert)

    private lazy var viewModel: WebViewViewModel = {
        let model = WebViewViewModel()
        return model
    }()

    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        webView.navigationDelegate = self
        initialize()
        setThemeColor()
        setupProgressBar()
    }

    func initialize() {
        TabsManager.shared.fetchTabs()
        SettingsManager.shared.initialize()
        if !TabsManager.shared.tabs.isEmpty {
            // TODO: Save last index
            let index = TabsManager.shared.initCurrentTab()
            guard let request = viewModel.request(url: TabsManager.shared.tabs[index].url) else { return }
            webView.load(request)
        } else {
            viewModel.isAddingTab = true
            addTab()
        }
    }

    func setupProgressBar() {
        webView.addObserver(self, forKeyPath:"estimatedProgress", options:.new, context:nil)
    }

    //ProgressBar Observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "estimatedProgress") {
            let progress = Float(webView.estimatedProgress)
            if(progressBar != nil) {
                // プログレスバーの更新
                if(progress < 1.0) {
                    progressBar.setProgress(progress, animated: true)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    //TODO: StopButtonの追加
//                    self.navigationItem.rightBarButtonItem = stopBtn
                } else {
                    // 読み込み完了
                    progressBar.setProgress(0.0, animated: false)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                    self.navigationItem.rightBarButtonItem = reloadBtn
//                    searchBar.text = webView.url?.absoluteString
                }
            }
        }
    }

    @objc func dismissKeyboard() {
        searchBar.endEditing(true)
    }

    func setThemeColor() {
        guard let color = Util().getThemeColor() else { return }
        tabBar.backgroundColor = color.adjust(by:70)
        tabBar.tintColor = color
        searchBar.backgroundColor = color.adjust(by:70)
    }

    func navigateToThemeViewController() {
        guard let navigationViewController = Navigator().instantiate(viewControllerClass: Navigator.Classes.Theme) as? UINavigationController else { return }
        let themeViewController = navigationViewController.topViewController as? ThemeViewController
        themeViewController?.delegate = self
        present(navigationViewController, animated: true, completion: nil)
    }

    func navigateToBookmarkViewController() {
        guard let navigationViewController = Navigator().instantiate(viewControllerClass: Navigator.Classes.BookmarkList) as? UINavigationController else { return }
        let bookmarkViewController = navigationViewController.topViewController as? BookmarkViewController
        bookmarkViewController?.delegate = self
        present(navigationViewController, animated: true, completion: nil)
    }

    func navigateToHistoryViewController() {
        guard let navigationViewController = Navigator().instantiate(viewControllerClass: Navigator.Classes.History) as? UINavigationController else { return }
        let historyViewContainer = navigationViewController.topViewController as? HistoryContainerViewController
        historyViewContainer?.delegate = self
        present(navigationViewController, animated: true, completion: nil)
    }

    func navigateToSettingsViewController() {
        guard let navigationViewController = Navigator().instantiate(viewControllerClass: Navigator.Classes.Settings) as? UINavigationController else { return }
//        let settingsViewController = navigationViewController.topViewController as? SettingsViewController
        present(navigationViewController, animated: true, completion: nil)
    }
}

extension WebViewController : UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        guard let selectedItem = viewModel.getToolbarItem(index: index) else { return }
        switch selectedItem {
        case .back:
            webView.goBack()
        case .forward:
            webView.goForward()
        case .reload:
            webView.reload()
        case .actions:
            showCircleMenu()
        case .more:
            guard let navigationViewController = Navigator().instantiate(viewControllerClass: Navigator.Classes.SideMenu) as? UINavigationController else { return }
            let sideMenuViewController = navigationViewController.topViewController as? SideMenuViewController
            sideMenuViewController?.delegate = self
            present(navigationViewController, animated: true, completion: nil)
            // TODO: deselect
        }
        tabBar.selectedItem = nil
    }
}

extension WebViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: suggestions
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let input = searchBar.text else { return }
        guard let url = viewModel.verifyUrl(urlString: input) else { return }
        let requester = viewModel.request(url: url)
        guard let request = requester else { return }
        webView.load(request)
        searchBar.text = request.url?.absoluteString
        searchBar.resignFirstResponder()
    }
}

extension WebViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        dismissKeyboard()
        return true
    }
}

extension WebViewController: CKCircleMenuDelegate {
    func circleMenuActivatedButton(with anIndex: Int32) {
        guard let selectedItem = viewModel.getActionItem(index: Int(anIndex)) else { return }
        switch selectedItem {
        case .addBookmark:
            addBookmarkModal()
        case .share:
            share()
        case .tabs:
            navigateToTabsViewController()
        case .addtab:
            viewModel.isAddingTab = true
            addTab()
        }
    }
    
    func circleMenuOpened() {
        tabBar.isUserInteractionEnabled = false
        webView.isUserInteractionEnabled = false
        searchBar.isUserInteractionEnabled = false
    }
    
    func circleMenuClosed() {
        tabBar.isUserInteractionEnabled = true
        webView.isUserInteractionEnabled = true
        searchBar.isUserInteractionEnabled = true
        removeTapGesture()
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewModel.saveHistory(url: webView.url?.absoluteString)
        if viewModel.isAddingTab {
            let imageData = viewModel.convertAndSaveImage(webView: webView)
            TabsManager.shared.makeTab(title: webView.title, url: webView.url?.absoluteString, image: imageData)
            viewModel.isAddingTab = false
            TabsManager.shared.changeCurrentTab(index: TabsManager.shared.tabs.count - 1)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let imageData = self.viewModel.convertAndSaveImage(webView: webView)
                TabsManager.shared.changeTab(title: webView.title, url: webView.url?.absoluteString, image: imageData)
            }
        }
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        searchBar.text = webView.url?.absoluteString
    }
}

extension WebViewController {
    func addBookmarkModal() {
        guard let bookmarkAddViewController = Navigator().instantiate(viewControllerClass: Navigator.Classes.BookmarkAdd) as? BookmarkAddViewController else { return }
        let parameters = viewModel.sendNonNullParameters(title: webView.title, url: webView?.url?.absoluteString)
        bookmarkAddViewController.setup(url: parameters.1, title: parameters.0)
        presenter.presentationType = .custom(width: ModalSize.custom(size: Float(view.frame.width)), height: ModalSize.custom(size:Float(view.frame.height / 1.2)), center: ModalCenterPosition.bottomCenter)
        customPresentViewController(presenter, viewController: UINavigationController(rootViewController: bookmarkAddViewController), animated: true, completion: nil)
    }

    func share() {
        guard let title = webView.title else { return }
        guard let url = webView.url else { return }
        let activityItems = [title, url] as [Any]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }

    func showCircleMenu() {
        viewModel.setCircleMenuPos(x: view.frame.midX, y: view.frame.midY)
        guard let circleMenu = viewModel.circleMenuView else { return }
        view.addSubview(circleMenu)
        circleMenu.delegate = self
        dismissCircleMenuTapGesture()
        circleMenu.openMenu()
    }

    func navigateToTabsViewController() {
        guard let navigationViewController = Navigator().instantiate(viewControllerClass: Navigator.Classes.Tabs) as? UINavigationController else { return }
        let tabsContainerViewController = navigationViewController.topViewController as? TabsContainerViewController
        tabsContainerViewController?.delegate = self
        presenter.presentationType = .custom(width: ModalSize.custom(size: Float(view.frame.width)), height: .full, center: ModalCenterPosition.bottomCenter)
        customPresentViewController(presenter, viewController: navigationViewController, animated: true, completion: nil)
    }

    func addTab() {
        let url = "http://google.com"
        guard let request = viewModel.request(url: url) else { return }
        webView.load(request)
    }

    private func dismissCircleMenuTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissCircleMenu))
        //        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    //全部外してるから、要注意
    private func removeTapGesture() {
        if let recognizers = view.gestureRecognizers {
            for recognizer in recognizers {
                view.removeGestureRecognizer(recognizer as UIGestureRecognizer)
            }
        }
    }

    @objc func dismissCircleMenu() {
        viewModel.circleMenuView?.closeMenu()
    }
}

extension WebViewController: ThemeViewDelegate {
    func setNewColor(color: String?) {
        guard let color = Util().getThemeColor(color: color) else { return }
        tabBar.backgroundColor = color.adjust(by:70)
        tabBar.tintColor = color
        searchBar.backgroundColor = color.adjust(by:70)
    }
}

extension WebViewController: BookmarkDelegate {
    func loadClickedUrl(url: String?) {
        guard let url = url else { return }
        guard let request = viewModel.request(url: url) else { return }
        webView.load(request)
    }
}

extension WebViewController: HistoryDelegate {
    func didSelectHistory(url: String) {
        guard let request = viewModel.request(url: url) else { return }
        webView.load(request)
    }
}

extension WebViewController: TabsDelegate {
    func closeAllTabs() {
        webView.reload()
    }
    
    func didSelectItemAt(tab: Tab) {
        guard let request = viewModel.request(url: tab.url) else { return }
        webView.load(request)
    }
}

extension WebViewController: SideMenuDelegate {
    func navigateToSettingsController() {
        navigateToSettingsViewController()
    }
    
    func navigateToHistoryController() {
        navigateToHistoryViewController()
    }

    func navigateToBookmarkController() {
        navigateToBookmarkViewController()
    }

    func navigateToThemeController() {
        navigateToThemeViewController()
    }
}

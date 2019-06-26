//
//  WebviewContainerViewController.swift
//  RicaWeb
//
//  Created by ricardo on 2019/06/26.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation
import Presentr
import CKCircleMenuView
import WebKit

class WebViewContainer: UIViewController {

    private lazy var viewModel: WebViewContainerViewModel = {
        let model = WebViewContainerViewModel()
        return model
    }()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var mainView: UIView!

    let presenter = Presentr(presentationType: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        setThemeColor()
        initialize()
        setupProgressBar()
        viewModel.viewDidLoad()
    }

    func initialize() {
        TabsManager.shared.fetchTabs()
        if !TabsManager.shared.tabs.isEmpty {
            // TODO: Save last index
            guard let request = viewModel.request(url: TabsManager.shared.tabs[0].url) else { return }
            viewModel.currentTab().load(request)
        } else {
            viewModel.isAddingTab = true
            addTab()
        }
    }

    func setupProgressBar() {
        viewModel.currentTab().addObserver(self, forKeyPath:"estimatedProgress", options:.new, context:nil)
    }

    //ProgressBar Observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "estimatedProgress") {
            let progress = Float(viewModel.currentTab().estimatedProgress)
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
                    searchBar.text = viewModel.currentTab().url?.absoluteString
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
}

extension WebViewContainer: SideMenuDelegate {
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

extension WebViewContainer: HistoryDelegate {
    func didSelectHistory(url: String) {
        guard let request = viewModel.request(url: url) else { return }
        viewModel.currentTab().load(request)
    }
}

extension WebViewContainer: BookmarkDelegate {
    func loadClickedUrl(url: String?) {
        guard let url = url else { return }
        guard let request = viewModel.request(url: url) else { return }
        viewModel.currentTab().load(request)
    }
}

extension WebViewContainer: ThemeViewDelegate {
    func setNewColor(color: String?) {
        guard let color = Util().getThemeColor(color: color) else { return }
        tabBar.backgroundColor = color.adjust(by:70)
        tabBar.tintColor = color
        searchBar.backgroundColor = color.adjust(by:70)
    }
}

extension WebViewContainer: TabsDelegate {
    func closeAllTabs() {
        viewModel.currentTab().reload()
    }
    
    func didSelectItemAt(tab: Tab) {
        guard let request = viewModel.request(url: tab.url) else { return }
        viewModel.currentTab().load(request)
    }
}

//ActionMenu
extension WebViewContainer: CKCircleMenuDelegate {
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
        viewModel.currentTab().isUserInteractionEnabled = false
    }
    
    func circleMenuClosed() {
        viewModel.currentTab().isUserInteractionEnabled = true
    }
}

extension WebViewContainer : UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        guard let selectedItem = viewModel.getToolbarItem(index: index) else { return }
        switch selectedItem {
        case .back:
            viewModel.currentTab().goBack()
        case .forward:
            viewModel.currentTab().goForward()
        case .reload:
            viewModel.currentTab().reload()
        case .actions:
            showCircleMenu()
        case .more:
            guard let navigationViewController = Navigator().instantiate(viewControllerClass: Navigator.Classes.SideMenu) as? UINavigationController else { return }
            let sideMenuViewController = navigationViewController.topViewController as? SideMenuViewController
            sideMenuViewController?.delegate = self
            present(navigationViewController, animated: true, completion: nil)
            // TODO: deselect
        }
    }
}

extension WebViewContainer: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: suggestions
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let input = searchBar.text else { return }
        guard let url = viewModel.verifyUrl(urlString: input) else { return }
        let requester = viewModel.request(url: url)
        guard let request = requester else { return }
        viewModel.currentTab().load(request)
        searchBar.text = request.url?.absoluteString
        searchBar.resignFirstResponder()
    }
}

extension WebViewContainer: WebViewDelegate {
    func passParams(webView: WKWebView) {
        print("成功")
    }
}

//ActionMenu Functions
extension WebViewContainer {
    func addBookmarkModal() {
        guard let bookmarkAddViewController = Navigator().instantiate(viewControllerClass: Navigator.Classes.BookmarkAdd) as? BookmarkAddViewController else { return }
        let parameters = viewModel.sendNonNullParameters(title: viewModel.currentTab().title, url: viewModel.currentTab().url?.absoluteString)
        bookmarkAddViewController.setup(url: parameters.1, title: parameters.0)
        presenter.presentationType = .custom(width: ModalSize.custom(size: Float(view.frame.width)), height: ModalSize.custom(size:Float(view.frame.height / 1.2)), center: ModalCenterPosition.bottomCenter)
        customPresentViewController(presenter, viewController: UINavigationController(rootViewController: bookmarkAddViewController), animated: true, completion: nil)
    }
    
    func share() {
        guard let title = viewModel.currentTab().title else { return }
        guard let url = viewModel.currentTab().url else { return }
        let activityItems = [title, url] as [Any]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    func showCircleMenu() {
        viewModel.setCircleMenuPos(x: view.frame.midX, y: view.frame.midY)
        guard let circleMenu = viewModel.circleMenuView else { return }
        view.addSubview(circleMenu)
        circleMenu.delegate = self
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
        let url = "https://google.com"
        guard let request = viewModel.request(url: url) else { return }
        viewModel.currentTab().load(request)
    }
}

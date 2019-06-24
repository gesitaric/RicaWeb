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

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        webView.navigationDelegate = self
        initialize()
        setThemeColor()
    }

    func initialize() {
        TabsManager.shared.fetchTabs()
        if !TabsManager.shared.tabs.isEmpty {
            TabsManager.shared.currentTab = viewModel.getLastIndex()
            guard let request = viewModel.request(url: TabsManager.shared.tabs[TabsManager.shared.currentTab ?? 0].url) else { return }
            webView.load(request)
        } else {
            viewModel.isAddingTab = true
            addTab()
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
        // TODO
        guard let navigationViewController = Navigator().instantiate(viewControllerClass: Navigator.Classes.History) as? UINavigationController else { return }
        let historyViewController = navigationViewController.topViewController as? HistoryViewController
        historyViewController?.delegate = self
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
    }
}

extension WebViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: suggestions
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let input = searchBar.text else { return }
        let requester = viewModel.verifyUrl(urlString: input) ? viewModel.request(url: input) : viewModel.request(url: viewModel.googleSearch(q: input))
        guard let request = requester else { return }
        webView.load(request)
        searchBar.text = request.url?.absoluteString
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
    }
    
    func circleMenuClosed() {
        tabBar.isUserInteractionEnabled = true
        webView.isUserInteractionEnabled = true
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewModel.saveHistory(url: webView.url?.absoluteString)
        if viewModel.isAddingTab {
            let imageData = viewModel.convertAndSaveImage(webView: webView)
            TabsManager.shared.makeTab(title: webView.title, url: webView.url?.absoluteString, image: imageData)
            viewModel.isAddingTab = false
            TabsManager.shared.currentTab = TabsManager.shared.tabs.count - 1
            viewModel.saveLastIndex(int: TabsManager.shared.currentTab)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let imageData = self.viewModel.convertAndSaveImage(webView: webView)
                TabsManager.shared.changeTab(title: webView.title, url: webView.url?.absoluteString, image: imageData)
                self.viewModel.saveLastIndex(int: TabsManager.shared.currentTab)
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
        circleMenu.openMenu()
    }

    func navigateToTabsViewController() {
        guard let navigationViewController = Navigator().instantiate(viewControllerClass: Navigator.Classes.Tabs) as? UINavigationController else { return }
        let tabsViewController = navigationViewController.topViewController as? TabsViewController
        tabsViewController?.delegate = self
        presenter.presentationType = .custom(width: ModalSize.custom(size: Float(view.frame.width)), height: .half, center: ModalCenterPosition.bottomCenter)
        customPresentViewController(presenter, viewController: navigationViewController, animated: true, completion: nil)
    }

    func addTab() {
        let url = "https://google.com"
        guard let request = viewModel.request(url: url) else { return }
        webView.load(request)
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
    func didSelectItemAt(tab: Tab) {
        guard let request = viewModel.request(url: tab.url) else { return }
        webView.load(request)
    }
}

extension WebViewController: SideMenuDelegate {
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

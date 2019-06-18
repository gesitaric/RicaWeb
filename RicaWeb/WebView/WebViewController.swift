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
    
    enum ToolbarItem: Int {
        case back = 0
        case forward
        case actions
        case more
    }

    enum ActionItem: Int {
        case addBookmark = 0
        case history
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()

        guard let request = viewModel.request(url: "https://www.google.com/") else { return }
        webView.load(request)
    }

    @objc func dismissKeyboard() {
        searchBar.endEditing(true)
    }
}

extension WebViewController : UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        guard let selectedItem = ToolbarItem(rawValue: index) else { return }
        switch selectedItem {
        case .back:
            webView.goBack()
        case .forward:
            webView.goForward()
        case .actions:
            viewModel.setCircleMenuPos(x: view.frame.midX, y: view.frame.midY)
            guard let circleMenu = viewModel.circleMenuView else { return }
            view.addSubview(circleMenu)
            circleMenu.delegate = self
            circleMenu.openMenu()
        case .more:
            let storyboard = UIStoryboard(name: "SideMenuViewController", bundle: nil)
            guard let sideMenuViewController = storyboard.instantiateInitialViewController() else { return }
            present(sideMenuViewController, animated: true, completion: nil)
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
        let newUrl: String?
        if viewModel.verifyUrl(urlString: input) != false {
            guard let request = viewModel.request(url: input) else { return }
            webView.load(request)
            newUrl = input
        } else {
            let googleSearch = viewModel.googleSearch(q: input)
            guard let request = viewModel.request(url: googleSearch) else { return }
            webView.load(request)
            newUrl = googleSearch
        }
        if let newUrl = newUrl {
            searchBar.text = newUrl
        }
    }
    //TODO: コードの整理とキーボードの表示のタイミング
}

extension WebViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        dismissKeyboard()
        return true
    }
}

extension WebViewController: CKCircleMenuDelegate {
    func circleMenuActivatedButton(with anIndex: Int32) {
        guard let selectedItem = ActionItem(rawValue: Int(anIndex)) else { return }
        switch selectedItem {
        case .addBookmark:
            let storyboard = UIStoryboard(name: "BookmarkAddViewController", bundle: nil)
            guard let bookmarkAddViewController = storyboard.instantiateInitialViewController() else { return }
            presenter.presentationType = .topHalf
            customPresentViewController(presenter, viewController: bookmarkAddViewController, animated: true, completion: nil)
        case .history:
            // TODO
            print("TODO")
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

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
        webView.uiDelegate = self

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
        guard let selectedItem = viewModel.getToolbarItem(index: index) else { return }
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
        let requester = viewModel.verifyUrl(urlString: input) ? viewModel.request(url: input) : viewModel.request(url: viewModel.googleSearch(q: input))
        guard let request = requester else { return }
        webView.load(request)
        searchBar.text = input
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
            guard let bookmarkAddViewController = Navigator().instantiate(viewControllerClass: Navigator.Classes.BookmarkAdd) as? BookmarkAddViewController else { return }
            let parameters = viewModel.sendNonNullParameters(title: webView.title, url: webView?.url?.absoluteString)
            bookmarkAddViewController.setup(url: parameters.1, title: parameters.0)
            presenter.presentationType = .custom(width: ModalSize.custom(size: Float(view.frame.width)), height: ModalSize.custom(size:Float(view.frame.height / 1.2)), center: ModalCenterPosition.bottomCenter)
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

extension WebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
}

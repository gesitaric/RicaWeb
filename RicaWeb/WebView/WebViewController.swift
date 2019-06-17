//
//  ViewController.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/15.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    private lazy var viewModel: WebViewViewModel = {
        let model = WebViewViewModel()
        return model
    }()

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    enum ToolbarItem: Int {
        case back = 0
        case forward
        case more
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                tabBar.selectedItem = nil
            }
        case .forward:
            webView.goForward()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                tabBar.selectedItem = nil
            }
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
        print("from searchbar delegate: \(searchText)")
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


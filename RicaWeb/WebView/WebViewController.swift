//
//  ViewController.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/15.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import UIKit
import SideMenu
import CKCircleMenuView
import WebKit

class WebViewController: UIViewController {

    private lazy var viewModel: WebViewViewModel = {
        let model = WebViewViewModel()
        return model
    }()

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        webView.navigationDelegate = self

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
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let imageData = self.viewModel.convertAndSaveImage(webView: webView)
                TabsManager.shared.changeTab(title: webView.title, url: webView.url?.absoluteString, image: imageData)
            }
        }
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    }
}

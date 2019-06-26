//
//  ViewController.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/15.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import UIKit
import SideMenu
import WebKit

protocol WebViewDelegate: class {
    func passParams(webView: WKWebView)
}

class WebViewController: UIViewController {

    private lazy var viewModel: WebViewViewModel = {
        let model = WebViewViewModel()
        return model
    }()

    @IBOutlet weak var webView: WKWebView!
    weak var delegate: WebViewDelegate?
    var viewController: WebViewContainer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: URL(string: "https://google.com")!))
        webView.navigationDelegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewController = parent as? WebViewContainer
        delegate = viewController
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        delegate?.passParams(webView: webView)
//        viewModel.saveHistory(url: webView.url?.absoluteString)
//        if viewModel.isAddingTab {
//            let imageData = viewModel.convertAndSaveImage(webView: webView)
//            TabsManager.shared.makeTab(title: webView.title, url: webView.url?.absoluteString, image: imageData)
//            viewModel.isAddingTab = false
//            TabsManager.shared.currentTab = TabsManager.shared.tabs.count - 1
//        } else {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                let imageData = self.viewModel.convertAndSaveImage(webView: webView)
//                TabsManager.shared.changeTab(title: webView.title, url: webView.url?.absoluteString, image: imageData)
//            }
//        }
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    }
}

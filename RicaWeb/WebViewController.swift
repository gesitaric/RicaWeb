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

    @IBOutlet weak var webView: WKWebView!

    enum ToolbarItem: Int {
        case back = 0
        case forward
        case more
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = "https://www.google.com/"
        let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

        guard let encodedUrl = encodedUrlString else { return }
        if let url = URL(string: encodedUrl) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
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


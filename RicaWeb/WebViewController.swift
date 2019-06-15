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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = "https://www.google.com/"
        let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

        guard let encodedUrl = encodedUrlString else { return }
        if let url = URL(string: encodedUrl) {
            let request = URLRequest(url: url)
            let userAgentStr = "RicaWeb"
            webView.customUserAgent = userAgentStr
            webView.load(request)
        }
    }
}


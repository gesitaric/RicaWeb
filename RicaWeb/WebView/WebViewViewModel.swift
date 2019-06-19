//
//  WebViewViewModel.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/17.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation
import UIKit
import Presentr

class WebViewViewModel {
    let presenter = Presentr(presentationType: .alert)

    var circleMenuImageArray = Array<UIImage>()
    var circleMenuView: CKCircleMenuView?

    func viewDidLoad() {
        setupCircleMenu()
    }

    func setupCircleMenu() {
        circleMenuImageArray.append(UIImage(named: "bookmark")!)
        circleMenuImageArray.append(UIImage(named: "history")!)
    }

    func setCircleMenuPos(x: CGFloat, y: CGFloat) {
        let tPoint = CGPoint(x: x, y: y)
        circleMenuView = CKCircleMenuView(atOrigin: tPoint, usingOptions: CircleMenu().initialize(), withImageArray: circleMenuImageArray)
    }

    func request(url: String) -> URLRequest? {
        let urlString = url
        let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        guard let encodedUrl = encodedUrlString else { return nil }
        if let url = URL(string: encodedUrl) {
            let request = URLRequest(url: url)
            return request
        }
        return nil
    }

    //TODO: urlかquerieかちゃんと調べる
    func verifyUrl (urlString: String?) -> Bool {
        guard let urlString = urlString else { return false }
        if let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }

    func googleSearch(q: String) -> String {
        return "http://www.google.com/search?q=" + q
    }
}

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

    var isAddingTab: Bool = false

    enum ToolbarItem: Int {
        case back = 0
        case forward
        case reload
        case actions
        case more
    }

    enum ActionItem: Int {
        case addBookmark = 0
//        case history
        case share
        case tabs
        case addtab
    }

    func viewDidLoad() {
        setupCircleMenu()
    }

    func setupCircleMenu() {
        circleMenuImageArray.append(UIImage(named: "bookmark_m")!)
//        circleMenuImageArray.append(UIImage(named: "history_m")!)
        circleMenuImageArray.append(UIImage(named: "share")!)
        circleMenuImageArray.append(UIImage(named: "tabs_m")!)
        circleMenuImageArray.append(UIImage(named: "addtab_m")!)
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

    func getToolbarItem(index: Int) -> ToolbarItem? {
        return ToolbarItem(rawValue: index)
    }

    func getActionItem(index: Int) -> ActionItem? {
        return ActionItem(rawValue: index)
    }

    func sendNonNullParameters(title: String?, url: String?) -> (String, String) {
        var sendTitle = "エラー"
        var sendUrl = "エラー"
        if let title = title { sendTitle = title }
        if let url = url { sendUrl = url }
        return (sendTitle, sendUrl)
    }

    func saveHistory(url: String?) {
        guard let url = url else { return }
        let history = History.mr_createEntity()
        history?.date = Date() as NSDate
        history?.url = url
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }

    func convertAndSaveImage(webView: UIView) -> String? {
        let image = Util().screenshot(webView)
        return Util().imageToString(image: image)
    }
}

//
//  WebViewContainerViewModel.swift
//  RicaWeb
//
//  Created by ricardo on 2019/06/26.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation
import WebKit
import CKCircleMenuView

class WebViewContainerViewModel {
    
    private var webView: WKWebView?

    var webViews: [WKWebView] = []
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
        case share
        case tabs
        case addtab
    }

    func viewDidLoad() {
        setupCircleMenu()
    }

    func setupCircleMenu() {
        circleMenuImageArray.append(UIImage(named: "bookmark_m")!)
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

    func verifyUrl (urlString: String?) -> String? {
        guard var urlString = urlString else { return nil }
        
        var stringUrl: String
        let checkUrl = urlString.components(separatedBy: ".")
        if checkUrl.count > 1 {
            // URLの場合
            if !urlString.hasPrefix("http://") || !urlString.hasPrefix("https://") {
                stringUrl = "http://"
                urlString = stringUrl.appending(urlString)
            }
        } else {
            // 検索ワード
            urlString = urlString.replacingOccurrences(of: "?", with: " ")
            let words = urlString.components(separatedBy: " ")
            let searchWord = words.joined(separator: "+")
            return googleSearch(q: searchWord)
        }
        return urlString
    }

    private func googleSearch(q: String) -> String {
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

    func currentTab() -> WKWebView {
        guard  let currentIndex = TabsManager.shared.currentTab else { return WKWebView() }
        return webViews[currentIndex]
    }

    func setWebView(webView: WKWebView) {
        self.webView = webView
    }
    
    func getWebView() -> WKWebView {
        guard let webView = webView else { return WKWebView() }
        return webView
    }
}

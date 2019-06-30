//
//  TabsManager.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/23.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation
import WebKit

class TabData
{
    init(webView: WKWebView, tab: Tab) {
        self.webView = webView
        self.tab = tab
    }

    var webView: WKWebView
    var tab: Tab
}

class TabsManager {
    var tabManager: Tab?
    var tabs: [TabData] = []
    var currentTab: Int?

    func makeTab(title: String?, url: String?, image: String?) {
        tabManager = Tab.mr_createEntity()
        tabManager?.title = title ?? "Unknown"
        tabManager?.url = url ?? "Unknown"
        tabManager?.image = image ?? nil
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        tabs.append(TabData(webView: WKWebView(), tab: tabManager!))
    }

    func changeTab(title: String?, url: String?, image: String?) {
        let currentTab = self.currentTab ?? tabs.count - 1
        tabs[currentTab].tab.title = title ?? "Unknown"
        tabs[currentTab].tab.url = url ?? "Unknown"
        tabs[currentTab].tab.image = image ?? nil
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }

    func fetchTabs() {
        tabManager = Tab()
        let tabs = tabManager?.readData() ?? []
        if !tabs.isEmpty {
            for tab in tabs {
                self.tabs.append(TabData(webView: WKWebView(), tab: tab))
            }
        }
    }

    func deleteTabs() {
        tabs.removeAll()
        Tab.mr_truncateAll()
        tabManager = Tab.mr_createEntity()
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        tabs.append(TabData(webView: WKWebView(), tab: tabManager!))
    }

    static let shared: TabsManager = {
        return TabsManager()
    }()
}

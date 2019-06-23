//
//  TabsManager.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/23.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

class TabsManager {
    var tabManager: Tab?
    var tabs: [Tab] = []
    var currentTab: Int?

    func makeTab(title: String?, url: String?, image: String?) {
        tabManager = Tab.mr_createEntity()
        tabManager?.title = title ?? "Unknown"
        tabManager?.url = url ?? "Unknown"
        tabManager?.image = image ?? nil
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        tabs.append(tabManager!)
    }

    func changeTab(title: String?, url: String?, image: String?) {
        let currentTab = self.currentTab ?? tabs.count - 1
        tabs[currentTab].title = title ?? "Unknown"
        tabs[currentTab].url = url ?? "Unknown"
        tabs[currentTab].image = image ?? nil
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }

    func fetchTabs() {
        tabManager = Tab()
        tabs = tabManager?.readData() ?? []
    }

    static let shared: TabsManager = {
        return TabsManager()
    }()
}

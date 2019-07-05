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
    private (set) var currentTab: Int?

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

    func deleteTabs() {
        tabs.removeAll()
        Tab.mr_truncateAll()
        tabManager = Tab.mr_createEntity()
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        tabs.append(tabManager!)
    }

    func changeCurrentTab(index: Int) {
        currentTab = index
        saveUserDefaults(index: index)
    }

    func deleteTab(index: Int) {
        let tab = tabs.remove(at: index)
        tab.mr_deleteEntity()
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }

    func initCurrentTab() -> Int {
        if UserDefaults.standard.object(forKey: Keys.currentIndexKey) != nil {
            let currentTab = UserDefaults.standard.integer(forKey: Keys.currentIndexKey)
            self.currentTab = currentTab
            return currentTab
        }
        self.currentTab = 0
        return 0
    }

    private func saveUserDefaults(index: Int) {
        UserDefaults.standard.set(index, forKey: Keys.currentIndexKey)
    }

    static let shared: TabsManager = {
        return TabsManager()
    }()
}

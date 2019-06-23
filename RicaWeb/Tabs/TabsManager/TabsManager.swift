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

    func makeTab(title: String?, url: String?) {
        tabManager = Tab.mr_createEntity()
        tabManager?.title = title ?? "Unknown"
        tabManager?.url = url ?? "Unknown"
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        tabs.append(tabManager!)
    }

    func fetchTabs() {
        tabManager = Tab()
        tabs = tabManager?.readData() ?? []
    }

    static let shared: TabsManager = {
        return TabsManager()
    }()
}

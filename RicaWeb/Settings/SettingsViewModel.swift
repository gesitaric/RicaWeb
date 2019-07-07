//
//  SettingsViewModel.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/30.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

protocol SettingsProtocol: class {
    
}

class SettingsViewModel {
    func changeHistory(enable: Bool) {
        SettingsManager.shared.historySet(enabled: enable)
    }

    func changeCookies(enable: Bool) {
        SettingsManager.shared.cookiesSet(enabled: enable)
    }

    func deleteHistory() {
        History.mr_truncateAll()
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }

    func deleteCookies(){
        // テストしないと
        HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
    }
}

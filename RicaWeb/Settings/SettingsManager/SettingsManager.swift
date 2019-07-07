//
//  SettingsManager.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/30.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

class SettingsManager {
    private (set) var cookies: Bool?
    private (set) var history: Bool?

    func initialize() {
        initializeCookies()
        initializeHistory()
    }

    private func initializeCookies() {
        let key = Keys.enableCookies
        if UserDefaults.standard.object(forKey: key) != nil {
            cookies = UserDefaults.standard.bool(forKey: key)
        } else {
            cookiesSet(enabled: true)
        }
    }

    private func initializeHistory() {
        let key = Keys.enableHistory
        if UserDefaults.standard.object(forKey: key) != nil {
            history = UserDefaults.standard.bool(forKey: key)
        } else {
            historySet(enabled: true)
        }
    }

    func historySet(enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: Keys.enableHistory)
    }

    func cookiesSet(enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: Keys.enableCookies)
    }

    static let shared: SettingsManager = {
        return SettingsManager()
    }()
}

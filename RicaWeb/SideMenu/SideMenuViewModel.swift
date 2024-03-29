//
//  SideMenuViewModel.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/16.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

class SideMenuViewModel {
    private let sections: [String] = ["メイン", "設定"]
    private let labels: [[String]] = [["ブックマーク","履歴"], ["テーマ", "設定"]]
    private let images: [[String]] = [["bookmark","history"], ["theme", "setting"]]

    func getImage(section: Int, row: Int) -> String {
        return images[section][row]
    }

    func getLabel(section: Int, row: Int) -> String {
        return labels[section][row]
    }

    func getLabelCountForSection(section: Int) -> Int {
        return labels[section].count
    }

    func getSection(section: Int) -> String {
        return sections[section]
    }

    func getLabelCount() -> Int {
        return labels.count
    }

    func getSectionCount() -> Int {
        return sections.count
    }
}

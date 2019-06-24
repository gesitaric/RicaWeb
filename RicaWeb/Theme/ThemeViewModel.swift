//
//  ThemeViewModel.swift
//  RicaWeb
//
//  Created by ricardo on 2019/06/20.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

class ThemeViewModel {
    public var sections: [String] = ["カラーリスト"]
    public var rows: [[UIColor]] = [[]]

    func viewDidLoad() {
        rows.append([UIColor]())
        rows[0] = UIColor.colors
    }

    func setupCell(indexPath: IndexPath, cell: UITableViewCell) -> UITableViewCell {
        let color = rows[indexPath.section][indexPath.row]
        cell.textLabel?.text = color.name
        cell.backgroundColor = color.adjust(by: 70)
        return cell
    }

    func setNewColor(indexPath: IndexPath) -> String? {
        let newColor = rows[indexPath.section][indexPath.row].name
        UserDefaults.standard.set(newColor, forKey: Keys.themeKey)
        return newColor
    }
}

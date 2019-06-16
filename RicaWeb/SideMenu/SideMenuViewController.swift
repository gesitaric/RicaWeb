//
//  SideMenuViewController.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/16.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuViewController: UITableViewController {

    let sections: [String] = ["メイン", "設定"]
    let labels: [[String]] = [["ブックマーク","履歴"] ,["テーマ"]]
    let images: [[String]] = [["bookmark","history"] ,["theme"]]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels[section].count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Reuse", for: indexPath) as? SideMenuCellViewController else { return UITableViewCell() }
        cell.setup(imageIcon: images[indexPath.section][indexPath.row],
                    label: labels[indexPath.section][indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO
    }
}

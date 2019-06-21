//
//  HistoryViewController.swift
//  RicaWeb
//
//  Created by ricardo on 2019/06/19.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation
import UIKit

class HistoryViewController: UITableViewController {

    private lazy var viewModel: HistoryViewModel = {
        let model = HistoryViewModel()
        return model
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setThemeColor()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Reuse", for: indexPath) as UITableViewCell
        cell.textLabel?.text = viewModel.rows[indexPath.section][indexPath.row]
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section]
    }

    func setThemeColor() {
        guard let color = Util().getThemeColor() else { return }
        tableView.backgroundColor = color.adjust(by:70)
    }
}

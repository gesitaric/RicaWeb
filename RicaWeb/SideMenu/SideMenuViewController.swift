//
//  SideMenuViewController.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/16.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import UIKit
import SideMenu

protocol SideMenuDelegate: class {
    func navigateToThemeController()
    func navigateToBookmarkController()
    func navigateToHistoryController()
}

class SideMenuViewController: UITableViewController {

    private lazy var viewModel: SideMenuViewModel = {
        let model: SideMenuViewModel = SideMenuViewModel()
        return model
    }()

    weak var delegate: SideMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setThemeColor(color: Util().getThemeColor())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getSectionCount()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getLabelCountForSection(section: section)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getSection(section: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Reuse", for: indexPath) as? SideMenuCellViewController else { return UITableViewCell() }
        cell.setup(imageIcon: viewModel.getImage(section: indexPath.section, row: indexPath.row), label:viewModel.getLabel(section: indexPath.section, row: indexPath.row))
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO enum
        if indexPath.row == 0 && indexPath.section == 0 {
            dismiss(animated: true, completion: {
                self.delegate?.navigateToBookmarkController()
            })
        } else if indexPath.row == 1 && indexPath.section == 0 {
            dismiss(animated: true, completion: {
                self.delegate?.navigateToHistoryController()
            })
        } else if indexPath.row == 0 && indexPath.section == 1 {
            dismiss(animated: true, completion: {
                self.delegate?.navigateToThemeController()
            })
        }
    }

    private func setThemeColor(color: UIColor?) {
        guard let color = color else { return }
        tableView.backgroundColor = color.adjust(by: 70)
    }
}

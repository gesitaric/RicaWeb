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

    private lazy var viewModel: SideMenuViewModel = {
        let model: SideMenuViewModel = SideMenuViewModel()
        return model
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
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
            guard let bookmarkViewController = Navigator().instantiate(viewControllerClass: Navigator.Classes.BookmarkList) else { return }
            present(bookmarkViewController, animated: true, completion: nil)
        } else if indexPath.row == 1 && indexPath.section == 0 {
            guard let bookmarkViewController = Navigator().instantiate(viewControllerClass: Navigator.Classes.History) else { return }
            present(bookmarkViewController, animated: true, completion: nil)
        }
    }
}

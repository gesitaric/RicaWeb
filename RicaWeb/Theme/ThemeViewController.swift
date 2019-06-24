//
//  ThemeViewController.swift
//  RicaWeb
//
//  Created by ricardo on 2019/06/20.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation
import SCLAlertView

protocol ThemeViewDelegate: class {
    func setNewColor(color: String?)
}

class ThemeViewController: UITableViewController {

    private lazy var viewModel: ThemeViewModel = {
        let model = ThemeViewModel()
        return model
    }()

    weak var delegate: ThemeViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Reuse", for: indexPath) as UITableViewCell
        return viewModel.setupCell(indexPath: indexPath, cell: cell)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newColor = viewModel.setNewColor(indexPath: indexPath)
        delegate?.setNewColor(color: newColor)
        dismiss(animated: true, completion: {
            SCLAlertView().showSuccess("テーマの変更", subTitle: "テーマの色が\(newColor!)に適用されました。")
        })
    }

    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

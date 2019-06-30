//
//  SettingsViewController.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/30.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation
import UIKit

// TODO: 他所に反映させる
class SettingsViewController: UITableViewController {

    private lazy var viewModel : SettingsViewModel = {
        let viewModel = SettingsViewModel()
        return viewModel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 1 {
            let alert = UIAlertController(title: nil, message: "クッキーを削除してもよろしいですか？", preferredStyle: .alert)
            let yesButton = UIAlertAction(title: "はい", style: .default, handler: {
                (action: UIAlertAction!) in
                self.viewModel.deleteCookies()
            })
            let noButton = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
            alert.addAction(yesButton)
            alert.addAction(noButton)
            present(alert, animated: true)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            let alert = UIAlertController(title: nil, message: "キャッシュを削除してもよろしいですか？", preferredStyle: .alert)
            let yesButton = UIAlertAction(title: "はい", style: .default, handler: nil)
            let noButton = UIAlertAction(title: "いいえ", style: .cancel, handler: {
                (action: UIAlertAction!) in
                print("TODO")
            })
            alert.addAction(yesButton)
            alert.addAction(noButton)
            present(alert, animated: true)
        } else if indexPath.section == 2 && indexPath.row == 1 {
            let alert = UIAlertController(title: nil, message: "履歴を消去してもよろしいですか？", preferredStyle: .alert)
            let yesButton = UIAlertAction(title: "はい", style: .default, handler: {
                (action: UIAlertAction!) in
                self.viewModel.deleteHistory()
            })
            let noButton = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
            alert.addAction(yesButton)
            alert.addAction(noButton)
            present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cookiesSwitch(_ sender: UISwitch) {
        DispatchQueue.main.async { self.viewModel.changeCookies(enable: sender.isOn) }
    }

    @IBAction func historySwitch(_ sender: UISwitch) {
        DispatchQueue.main.async { self.viewModel.changeHistory(enable: sender.isOn) }
    }
}

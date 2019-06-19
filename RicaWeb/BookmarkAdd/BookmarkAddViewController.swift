//
//  BookmarkAddViewController.swift
//  RicaWeb
//
//  Created by ricardo on 2019/06/18.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

class BookmarkAddViewController: UITableViewController {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var urlIcon: UIImageView!
    @IBOutlet weak var urlLabel: UILabel!

    private lazy var viewModel: BookmarkAddViewModel = {
        let model = BookmarkAddViewModel()
        return model
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionsCount()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }

    @IBAction func addButton(_ sender: UIButton) {
        let result = viewModel.saveBookmark(title: titleField.text)
        switch result {
        case .success:
            SCLAlertView().showSuccess("ブックマークを保存しました", subTitle: "追加されたブックマークは、ブックマーク一覧からアクセスができます")
            dismiss(animated: true, completion: nil)
        case .emptyField:
            SCLAlertView().showWarning("タイトルは空っぽです", subTitle: "タイトルを入力してください")
        case .error:
            SCLAlertView().showError("ブックマークを保存できませんでした", subTitle: "恐れ入りますが、確認してもう一度入力してください")
        }
    }

    func setup(url: String, title: String) {
        viewModel.setup(url: url, title:  title)
    }

    func getData() {
        if let title = viewModel.title { titleField.text = title }
        if let imageUrl = viewModel.image { urlIcon.image = Util().getIconFromUrl(url: imageUrl) }
        if let url = viewModel.url { urlLabel.text = url }
    }
}

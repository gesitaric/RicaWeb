//
//  BookmarkAddViewController.swift
//  RicaWeb
//
//  Created by ricardo on 2019/06/18.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation
import UIKit

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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }

    @IBAction func addButton(_ sender: UIButton) {
    }

    func setup(image: String, url: String, title: String) {
        viewModel.setup(image: image, url: url, title:  title)
    }

    func getData() {
        if let title = viewModel.title { titleField.text = title }
        if let imageUrl = viewModel.image { urlIcon.image = Util().getIconFromUrl(url: imageUrl) }
        if let url = viewModel.url { urlLabel.text = url }
    }
}

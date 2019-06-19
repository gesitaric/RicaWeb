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

    private var imageString: String?
    private var urlString: String?
    private var titleString: String?

    private lazy var viewModel: BookmarkAddViewModel = {
        let model = BookmarkAddViewModel()
        return model
    }()

    enum Section: Int {
        case inputField = 0
        case buttonField
    }
    //TODO hange to tableview
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.text = titleString ?? "ERROOR"
        urlLabel.text = urlString ?? "erroro"
        let imageUrl = "https://www.google.com/s2/favicons?domain=" + urlString!
        urlIcon.image = Util().getIconFromUrl(url: imageUrl)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .inputField:
            return 2
        case .buttonField:
            return 1
        }
    }

    @IBAction func addButton(_ sender: UIButton) {
    }

    func setup(image: String, url: String, title: String) {
        self.imageString = image
        self.urlString = url
        self.titleString = title
    }
}

//
//  BookmarkViewController.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/17.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import UIKit

class BookmarkViewController: UITableViewController {

    private lazy var viewModel: BookmarkViewModel = {
        let model = BookmarkViewModel()
        return model
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.save()
    }
}

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
        viewModel.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getBookmarksCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Reuse", for: indexPath) as? SideMenuCellViewController else { return UITableViewCell() }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO
    }
}

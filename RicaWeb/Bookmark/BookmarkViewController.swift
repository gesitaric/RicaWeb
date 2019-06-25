//
//  BookmarkViewController.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/17.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import UIKit

protocol BookmarkDelegate: class {
    func loadClickedUrl(url: String?)
}

class BookmarkViewController: UITableViewController {

    private lazy var viewModel: BookmarkViewModel = {
        let model = BookmarkViewModel()
        return model
    }()

    weak var delegate: BookmarkDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setThemeColor()
    }

    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getBookmarksCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell", for: indexPath) as? BookmarkCellViewController else { return UITableViewCell() }
        guard let bookmark = viewModel.getBookmarkDetails(index: indexPath.row) else { return UITableViewCell() }
        cell.setup(imageIcon: bookmark.imageUrl, title: bookmark.title, url: bookmark.url )
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookmark = viewModel.getBookmarkDetails(index: indexPath.row)
        dismiss(animated: true, completion: {
            self.delegate?.loadClickedUrl(url: bookmark?.url)
        })
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
//            self.viewModel.deleteRow(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteButton.backgroundColor = UIColor.red
        return [deleteButton]
    }

    func setThemeColor() {
        guard let color = Util().getThemeColor() else { return }
        tableView.backgroundColor = color.adjust(by:70)
    }
}

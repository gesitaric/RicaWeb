//
//  HistoryContainerViewController.swift
//  RicaWeb
//
//  Created by ricardo on 2019/06/20.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

class HistoryContainerViewController: UIViewController {
    var viewController: HistoryViewController?
    
    weak var delegate: HistoryDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewController = children.first as? HistoryViewController
        viewController?.delegate = delegate
    }

    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteHistoryButton(_ sender: UIButton) {
        guard let isEditing = viewController?.tableView.isEditing else { return }
        viewController?.tableView.setEditing(!isEditing, animated: true)
    }
}

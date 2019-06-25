//
//  HistoryContainerViewController.swift
//  RicaWeb
//
//  Created by ricardo on 2019/06/20.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

class HistoryContainerViewController: UIViewController {
    
    weak var delegate: HistoryDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        let child = children.first as? HistoryViewController
        child?.delegate = delegate
    }

    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

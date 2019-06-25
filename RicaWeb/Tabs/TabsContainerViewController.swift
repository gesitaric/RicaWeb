//
//  TabsContainerViewController.swift
//  RicaWeb
//
//  Created by ricardo on 2019/06/25.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

class TabsContainerViewController: UIViewController {

    weak var delegate: TabsDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        let child = children.first as? TabsViewController
        child?.delegate = delegate
    }
    
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

//
//  SideMenuCellViewController.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/16.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import UIKit

class SideMenuCellViewController: UITableViewCell {
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var label: UILabel!

    func setup(imageIcon: String, label: String) {
        self.imageIcon.image = UIImage(named: imageIcon)
        self.label.text = label
    }
}

//
//  TabsCellViewController.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/23.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

class TabsCellViewController: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var image: UIImageView!
    var buttonAction: ((Any) -> Void)?

    @IBAction func deleteTab(_ sender: Any) {
        self.buttonAction?(sender)
    }
}

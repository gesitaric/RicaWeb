//
//  BookmarkCellViewController.swift
//  RicaWeb
//
//  Created by ricardo on 2019/06/18.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

class BookmarkCellViewController: UITableViewCell {
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var url: UILabel!

    func setup(imageIcon: String, title: String, url: String) {
        if let image = Util().getIconFromUrl(url: imageIcon) {
            self.imageIcon.image = image
        }
        self.title.text = title
        self.url.text = url
    }
}

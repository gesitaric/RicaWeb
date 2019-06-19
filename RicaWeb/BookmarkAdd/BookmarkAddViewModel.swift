//
//  BookmarkAddViewModel.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/18.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

class BookmarkAddViewModel {
    private (set) var image: String?
    private (set) var url: String?
    private (set)  var title: String?

    enum Section: Int {
        case inputField = 0
        case buttonField
    }

    func setup(image: String, url: String, title: String) {
        self.image = "https://www.google.com/s2/favicons?domain=" + image
        self.url = url
        self.title = title
    }

    func numberOfRowsInSection(section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .inputField:
            return 2
        case .buttonField:
            return 1
        }
    }
}

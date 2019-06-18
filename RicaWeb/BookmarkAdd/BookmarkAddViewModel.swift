//
//  BookmarkAddViewModel.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/18.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

class BookmarkAddViewModel {
    private var image: String?
    private var url: String?
    private var title: String?

    func setup(image: String, url: String, title: String) {
        self.image = image
        self.url = url
        self.title = title
    }

    func getImage() -> UIImage? {
        guard let image = self.image else { return nil }
        return Util().getIconFromUrl(url: image)
    }

    func getUrl() -> String? {
        guard let url = self.url else { return nil }
        return url
    }

    func getTitle() -> String? {
        guard let title = self.title else { return nil }
        return title
    }
}

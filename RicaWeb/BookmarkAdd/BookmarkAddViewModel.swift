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
    private (set) var title: String?

    enum Section: Int, CaseIterable {
        case inputField = 0
        case buttonField
    }

    enum Result: Int {
        case success = 0
        case emptyField
        case error
    }

    func setup(url: String, title: String) {
        self.image = "https://www.google.com/s2/favicons?domain=" + url
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

    func sectionsCount() -> Int {
        return Section.allCases.count
    }

    func saveBookmark(title: String?) -> Result {
        guard let title = title else { return .error }
        guard !title.isEmpty else { return .emptyField }
        if let image = self.image, let url = self.url {
            let bookmark = Bookmark(context: NSManagedObjectContext.mr_default())
            return bookmark.writeData(title: title, url: url, imageUrl: image) ? .success : .error
        }
        return .error
    }
}

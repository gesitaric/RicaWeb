//
//  BookmarkAddViewModel.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/18.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

class BookmarkAddViewModel {
    var bookmark: Bookmark?

    private (set) var image: String?
    private (set) var url: String?
    private (set) var title: String?

    enum Section: Int, CaseIterable {
        case inputField = 0
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
        }
    }

    func sectionsCount() -> Int {
        return Section.allCases.count
    }

    func saveBookmark(title: String?) -> Result {
        guard let title = title else { return .error }
        guard !title.isEmpty else { return .emptyField }

        if let image = self.image, let url = self.url {
            if let bookmark = Util().checkIfExists(url: url) {
                bookmark.title = title
                bookmark.imageUrl = image
                bookmark.date = Date() as NSDate
                return .success
            } else {
                bookmark = Bookmark.mr_createEntity()
                bookmark?.title = title
                bookmark?.imageUrl = image
                bookmark?.date = Date() as NSDate
                bookmark?.url = url
                NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                return .success
            }
        }
        return .error
    }
}

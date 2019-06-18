//
//  BookmarkViewModel.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/17.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation
import CoreData

class BookmarkViewModel {
    private var bookmarks: [Bookmark] = []

    func saveBookmark(title: String, url: String) {
        let bookmark = Bookmark()
        let result = bookmark.writeData(title: title, url: url)
        print(result)
    }

    func fetchBookmarks() -> [Bookmark] {
        let bookmark = Bookmark()
        let result = bookmark.readData()
        return result
    }

    func viewDidLoad() {
        self.bookmarks = fetchBookmarks()
    }

    func getBookmarksCount() -> Int {
        return bookmarks.count
    }
}

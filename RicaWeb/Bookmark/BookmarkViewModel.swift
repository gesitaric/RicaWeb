//
//  BookmarkViewModel.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/17.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

class BookmarkViewModel {
    var bookmark: Bookmark?
    private var bookmarks: [Bookmark] = []

    func fetchBookmarks() -> [Bookmark] {
        return self.bookmarks
    }

    func viewDidLoad() {
        bookmark = Bookmark()
        self.bookmarks = bookmark?.readData() ?? []
    }

    func getBookmarksCount() -> Int {
        return self.bookmarks.count
    }

    func getBookmarkDetails(index: Int) -> Bookmark? {
        guard self.bookmarks.contains(bookmarks[index]) else { return nil }
        return bookmarks[index]
    }
}

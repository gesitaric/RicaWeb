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
    private var bookmarkEntity: Bookmark?

    func saveBookmark(title: String, url: String, imageUrl: String) {
        guard let bookmark = bookmarkEntity else { return }
        let result = bookmark.writeData(title: title, url: url, imageUrl: imageUrl)
        print(result)
    }

    func fetchBookmarks() -> [Bookmark] {
        guard let bookmark = bookmarkEntity else { return [] }
        return bookmark.readData()
    }

    func viewDidLoad() {
        bookmarkEntity = Bookmark(context: NSManagedObjectContext.mr_default())
        saveBookmark(title: "Google", url: "www.google.com", imageUrl: "https://www.google.com/s2/favicons?domain=www.google.com")
        saveBookmark(title: "Yahoo", url: "www.yahoo.co.jp", imageUrl: "https://www.google.com/s2/favicons?domain=www.yahoo.co.jp")
        self.bookmarks = fetchBookmarks()
    }

    func getBookmarksCount() -> Int {
        return bookmarks.count
    }

    func getBookmarkDetails(index: Int) -> Bookmark? {
        //TODO: test a lot
        guard bookmarks.indices ~= index else { return nil }
        return bookmarks[index]
    }
}

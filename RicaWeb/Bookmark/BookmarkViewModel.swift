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
    func save() {
        let bookmark = Bookmark()
        let result = bookmark.writeData(title: "test", url: "test")
        print(result)
    }
}

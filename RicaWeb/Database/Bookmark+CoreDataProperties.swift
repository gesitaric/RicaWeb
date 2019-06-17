//
//  Bookmark+CoreDataProperties.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/17.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//
//

import Foundation
import CoreData


extension Bookmark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bookmark> {
        return NSFetchRequest<Bookmark>(entityName: "Bookmark")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var url: String?

    // データ登録/更新
    func writeData(title: String, url: String) -> Bool {
        var ret = false
        let bookmarkList = Bookmark.mr_findAll()
        if bookmarkList!.count > 0 {
            // 検索して見つかったらアップデートする
            let bookmark = bookmarkList![0] as! Bookmark
            bookmark.title = title
            bookmark.url = url
            bookmark.managedObjectContext!.mr_saveToPersistentStoreAndWait()
            ret = true
        }else{
            // 見つからなかったら新規登録
            let bookmark: Bookmark = Bookmark.mr_createEntity()! as Bookmark
            bookmark.title = title
            bookmark.url = url
            bookmark.managedObjectContext!.mr_saveToPersistentStoreAndWait()
            ret = true
        }
        return ret
    }

    // データ読み込み
    func readData() -> [Bookmark] {
        let bookmarkList = Bookmark.mr_findAll()
        guard let bookmarks = bookmarkList else { return [] }
        return bookmarks.isEmpty ? [] : bookmarkList as! [Bookmark]
    }

//    // データ削除
//    func deleteData() -> Bool {
//        var ret = false
//
//        let memoList = Memo.MR_findAll()
//        if memoList!.count > 0 {
//            // 検索して見つかったら削除
//            let memo = memoList![0] as! Memo
//            print("DELETE:\(memo.text)")
//            memo.MR_deleteEntity()
//            memo.managedObjectContext!.MR_saveToPersistentStoreAndWait()
//            ret = true
//        }
//        return ret
//    }
}

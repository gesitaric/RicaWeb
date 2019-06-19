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

    @NSManaged public var title: String
    @NSManaged public var url: String
    @NSManaged public var imageUrl: String
    @NSManaged public var date: NSDate
    @NSManaged public var index: Int32

    // データ読み込み
    func readData() -> [Bookmark] {
        let bookmarkList = Bookmark.mr_findAllSorted(by: "index", ascending: true) as? [Bookmark]
        guard let bookmarks = bookmarkList else { return [] }
        return !bookmarks.isEmpty ? bookmarks : []
    }

    func getCount() -> Int {
        return Bookmark.mr_findAll()?.count ?? 0
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

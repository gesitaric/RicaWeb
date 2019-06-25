//
//  HistoryViewModel.swift
//  RicaWeb
//
//  Created by ricardo on 2019/06/19.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

class HistoryViewModel {
    public var sections: [String] = []
    public var rows: [[String]] = [[]]
    private var histories: [[History]] = []

    func viewDidLoad() {
        setTable()
    }

    private func getHistories() -> [History] {
        guard let histories =  History.mr_findAllSorted(by: "date", ascending: false) else { return [] }
        return histories as! [History]
    }

    private func setTable() {
        let histories = getHistories()
        if !histories.isEmpty {
            var dates: [String] = []
            var urls: [[String]] = [[]]
            for history in histories {
                let date = Util().dateFormatter(date: history.date as Date)
                if !dates.contains(date) {
                    dates.append(date)
                    urls.append([String]())
                    //削除用
                    self.histories.append([History]())
                }
                urls[dates.count - 1].append(history.url)
                //削除用
                self.histories[dates.count - 1].append(history)
            }
            self.sections = dates
            self.rows = urls
        }
    }

    func deleteRow(indexPath: IndexPath) {
        rows[indexPath.section].remove(at: indexPath.row)
        //DBの削除
        let historyToDelete = histories[indexPath.section].remove(at: indexPath.row)
        historyToDelete.mr_deleteEntity()
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }
}

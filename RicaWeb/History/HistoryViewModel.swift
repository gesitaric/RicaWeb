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
    public var histories: [[History]] = []

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
            for history in histories {
                let date = Util().dateFormatter(date: history.date as Date)
                if !dates.contains(date) {
                    dates.append(date)
                    self.histories.append([History]())
                }
                self.histories[dates.count - 1].append(history)
            }
            self.sections = dates
        }
    }

    func deleteRow(indexPath: IndexPath) {
        let historyToDelete = histories[indexPath.section].remove(at: indexPath.row)
        historyToDelete.mr_deleteEntity()
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }
}

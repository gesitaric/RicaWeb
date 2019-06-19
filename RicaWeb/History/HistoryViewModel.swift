//
//  HistoryViewModel.swift
//  RicaWeb
//
//  Created by ricardo on 2019/06/19.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

class HistoryViewModel {
    public var sections: [String] = ["1994/02/21", "2019/12/21"]
    public var rows: [[String]] = [["www.italoricardogeske.neylify.com", "www.google.com"], ["www.yahoo.cp.jp"]]

    func viewDidLoad() {
        
    }

//    private func getHistories() -> [History] {
//        return History.mr_findAll() as? [History] ?? []
//    }
//
//    private func setTable(histories: [History]) {
//        // TODO
//    }
    // TODO tem que fazer relationship com o History e o UrlHistory, senao ja deleta essa merda de MagicalRecord
}

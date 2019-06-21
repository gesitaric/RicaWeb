//
//  ThemeViewModel.swift
//  RicaWeb
//
//  Created by ricardo on 2019/06/20.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

class ThemeViewModel {
    public var sections: [String] = ["カラーリスト"]
    public var rows: [[UIColor]] = [[]]

    func viewDidLoad() {
        rows.append([UIColor]())
        rows[0] = UIColor.colors
    }
}

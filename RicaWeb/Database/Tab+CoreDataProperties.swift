//
//  Tab+CoreDataProperties.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/23.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//
//

import Foundation
import CoreData


extension Tab {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tab> {
        return NSFetchRequest<Tab>(entityName: "Tab")
    }

    @NSManaged public var url: String
    @NSManaged public var title: String
    @NSManaged public var image: String?

    func readData() -> [Tab] {
        let tabList = Tab.mr_findAll() as? [Tab]
        guard let tabs = tabList else { return [] }
        return !tabs.isEmpty ? tabs : []
    }

}

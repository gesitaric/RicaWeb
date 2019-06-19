//
//  Util.swift
//  RicaWeb
//
//  Created by ricardo on 2019/06/18.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

class Util {
    func getIconFromUrl(url: String) -> UIImage? {
        guard let url = URL(string: url) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch let error {
            print("ERROR : \(error.localizedDescription)")
            return nil
        }
    }

    func checkIfExists(url: String) -> Bookmark? {
        let fetchRequest = NSFetchRequest<Bookmark>(entityName: "Bookmark")
        fetchRequest.predicate = NSPredicate(format: "url == %@", url)
        var results: [Bookmark] = []
        do {
            results = try NSManagedObjectContext.mr_default().fetch(fetchRequest)
            if !results.isEmpty {
                return results.first
            }
        } catch {
            print("Error")
        }
        return nil
    }
}

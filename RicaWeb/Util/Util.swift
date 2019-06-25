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

    func generateRandomDate(daysBack: Int) -> Date? {
        let day = arc4random_uniform(UInt32(daysBack)) + 1
        let hour = arc4random_uniform(23)
        let minute = arc4random_uniform(59)
        
        let today = Date(timeIntervalSinceNow: 0)
        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.day = -1 * Int(day - 1)
        offsetComponents.hour = -1 * Int(hour)
        offsetComponents.minute = -1 * Int(minute)
        
        let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
        return randomDate
    }

    func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }

    func getThemeColor(color: String? = nil) -> UIColor? {
        let colorName = color ?? UserDefaults.standard.string(forKey: Keys.themeKey)
        for color in UIColor.colors {
            if color.name == colorName {
                return color
            }
        }
        return nil
    }

    func screenshot(_ view: UIView?) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view?.bounds.size ?? CGSize.zero, _: true, _: 0)
        view?.drawHierarchy(in: view?.bounds ?? CGRect.zero, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func imageToString(image: UIImage?) -> String? {
        guard let image = image else { return nil }
        guard let data = image.pngData() as NSData? else { return nil }
        let pngData = data
        let encodeString =
            pngData.base64EncodedString(options: .lineLength64Characters)
        return encodeString
    }

    func stringToImage(imageString:String?) -> UIImage? {
        guard let imageString = imageString else { return nil }
        //空白を+に変換する
        let base64String = imageString.replacingOccurrences(of: " ", with:"+")
        //BASE64の文字列をデコードしてNSDataを生成
        let decodeBase64 =
            NSData(base64Encoded:base64String, options: .ignoreUnknownCharacters)
        //NSDataの生成が成功していたら
        if let decodeSuccess = decodeBase64 {
            //NSDataからUIImageを生成
            let img = UIImage(data: decodeSuccess as Data)
            //結果を返却
            return img
        }
        return nil
        
    }
}

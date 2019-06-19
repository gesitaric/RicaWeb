//
//  Navigator.swift
//  RicaWeb
//
//  Created by ricardo on 2019/06/19.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

class Navigator {
    enum Classes: String {
        case BookmarkList = "BookmarkViewController"
        case BookmarkAdd = "BookmarkAddViewController"
        case SideMenu = "SideMenuViewController"
    }

    func instantiate(viewControllerClass: Classes) -> UIViewController? {
        let storyboard = UIStoryboard(name: viewControllerClass.rawValue, bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() else { return nil }
        return viewController
    }

//    static let shared: Navigator = {
//        return Navigator()
//    }()
}

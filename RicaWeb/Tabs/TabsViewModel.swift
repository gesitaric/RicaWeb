//
//  TabsViewModel.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/23.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

class TabsViewModel {

    var themeColor: UIColor?

    func viewDidLoad() {
        themeColor = Util().getThemeColor()
    }

    func getIndexPath() -> IndexPath {
        let index = TabsManager.shared.currentTab ?? TabsManager.shared.tabs.count - 1
        return IndexPath(item: index, section: 0)
    }

    func setupCell(cell: TabsCellViewController, indexPath: IndexPath) -> TabsCellViewController {
        let model = TabsManager.shared.tabs[indexPath.item]
        cell.title.text = model.title
        cell.image.image = Util().stringToImage(imageString: model.image)
        cell.backgroundColor = themeColor?.adjust(by: 40)
        return cell
    }

    func deleteTab(index: Int) {
        TabsManager.shared.deleteTab(index: index)
    }
}

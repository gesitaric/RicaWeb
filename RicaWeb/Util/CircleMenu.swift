//
//  CircleMenu.swift
//  RicaWeb
//
//  Created by ricardo on 2019/06/18.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

class CircleMenu {
    func initialize() -> Dictionary<String, AnyObject> {
        var tOptions = Dictionary<String, AnyObject>()
        let color = setThemeColor()
        tOptions[CIRCLE_MENU_OPENING_DELAY] = 0.1 as AnyObject
        tOptions[CIRCLE_MENU_MAX_ANGLE] = 180.0 as AnyObject
        tOptions[CIRCLE_MENU_RADIUS] = 105.0 as AnyObject
        tOptions[CIRCLE_MENU_DIRECTION] = Int(CircleMenuDirectionUp.rawValue) as AnyObject
        tOptions[CIRCLE_MENU_BUTTON_BACKGROUND_NORMAL] = color?.adjust(by:70) ?? UIColor.lightGray
        tOptions[CIRCLE_MENU_BUTTON_BACKGROUND_ACTIVE] = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
        tOptions[CIRCLE_MENU_BUTTON_BORDER] = color ?? UIColor.white
        tOptions[CIRCLE_MENU_DEPTH] = 2.0 as AnyObject
        tOptions[CIRCLE_MENU_BUTTON_RADIUS] = 35.0 as AnyObject
        tOptions[CIRCLE_MENU_BUTTON_BORDER_WIDTH] = 2.0 as AnyObject
        tOptions[CIRCLE_MENU_TAP_MODE] = true as AnyObject
        tOptions[CIRCLE_MENU_LINE_MODE] = false as AnyObject
        tOptions[CIRCLE_MENU_BUTTON_TINT] = false as AnyObject
        tOptions[CIRCLE_MENU_BACKGROUND_BLUR] = false as AnyObject
        tOptions[CIRCLE_MENU_BUTTON_TITLE_VISIBLE] = true as AnyObject
        tOptions[CIRCLE_MENU_BUTTON_TITLE_FONT_SIZE] = 11.0 as AnyObject
        return tOptions
    }

    func setThemeColor() -> UIColor? {
        guard let color = Util().getThemeColor() else { return nil }
        return color
    }
}

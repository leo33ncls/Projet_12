//
//  UIColor.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 02/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    /// Custom gray color
    public class var customGrey: UIColor {
        return UIColor(red: 51/255, green: 47/255, blue: 46/255, alpha: 1.0)
    }

    /// Custom orange color
    public class var customOrange: UIColor {
        return UIColor(red: 255/255, green: 94/255, blue: 0/255, alpha: 1.0)
    }

    /// Custom light orange color
    public class var customLightOrange: UIColor {
        return UIColor(red: 255/255, green: 147/255, blue: 0/255, alpha: 1.0)
    }

    /// Placeholder gray color
    public class var placeholderGray: UIColor {
        return UIColor(red: 199/255, green: 199/255, blue: 205/255, alpha: 1.0)
    }
}

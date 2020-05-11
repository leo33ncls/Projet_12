//
//  CustomTabBarController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 11/05/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barStyle = .black
        tabBar.barTintColor = UIColor.customGrey
        tabBar.backgroundColor = UIColor.customGrey
        tabBar.tintColor = UIColor.customLightOrange

       guard let items = tabBar.items else { return }
        items[0].title = NSLocalizedString("SERIES", comment: "")
        items[1].title = NSLocalizedString("FORUM", comment: "")
        items[2].title = NSLocalizedString("SEARCH", comment: "")
        items[3].title = NSLocalizedString("ACCOUNT", comment: "")
    }
}

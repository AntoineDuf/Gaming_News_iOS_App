//
//  TabBarController.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 08/09/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    var viewModel = TabBarViewModel()
    var tabBarItemSelection = 0

    override func viewDidLoad() {
        selectedIndex = viewModel.selectedItem
    }
}

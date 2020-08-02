//
//  RSSFeedViewController.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 01/08/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit

class RSSFeedViewController: UITableViewController {
    var viewModel: RSSFeedViewModel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print(viewModel.articles[0])
    }
}

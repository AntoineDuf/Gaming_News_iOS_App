//
//  TableViewSection.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 06/11/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation
import AlamofireRSSParser

struct TableViewSection {

    let order: Int
    var items: [RSSItem]
    let headerTitle: String?
//    let headerHeight: CGFloat
//    let footerHeight: CGFloat
    init(
        order: Int = 0,
        items: [RSSItem],
        headerTitle: String? = nil
    ) {
        self.order = order
        self.items = items
        self.headerTitle = headerTitle
    }
}

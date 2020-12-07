//
//  TableViewSection.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 06/11/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation
import AlamofireRSSParser

struct RSSArticleByDay {
    let order: Int
    var items = [RSSItem]()
    let headerTitle: String
//    let headerHeight: CGFloat
//    let footerHeight: CGFloat
    init(
        order: Int,
        headerTitle: String
    ) {
        self.order = order
        self.headerTitle = headerTitle
    }
}

extension RSSArticleByDay {
    public mutating func sortItems() {
        let sortedItems = items.sorted { (itemOne, itemTwo) -> Bool in
            guard let itemOnePubDate = itemOne.pubDate,
                  let itemTwoPubDate = itemTwo.pubDate else { return false }
            return itemOnePubDate.compare(itemTwoPubDate) == .orderedDescending
        }
        items = sortedItems
    }
}

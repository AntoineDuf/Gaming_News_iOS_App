//
//  RSSItem+Equatable.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 22/10/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import AlamofireRSSParser

extension RSSItem: Hashable, Equatable {
    public static func == (lhs: RSSItem, rhs: RSSItem) -> Bool {
        return lhs.title == rhs.title
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

extension Array where Element: Hashable {
    var unique: [Element] {
        return Array(Set(self))
    }
}

extension RSSArticleByDay {
    public mutating func sortItems() {
        return self.items = self.items.sorted(by: {
            $0.pubDate!.compare($1.pubDate!) == .orderedDescending
        })
    }
}

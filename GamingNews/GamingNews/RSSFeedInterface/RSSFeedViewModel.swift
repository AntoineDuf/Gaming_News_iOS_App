//
//  RSSFeedViewModel.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 01/08/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation
import AlamofireRSSParser

class RSSFeedViewModel {
    var articles: [RSSItem]
    
    init(articles: [RSSItem]) {
        self.articles = articles
    }
}

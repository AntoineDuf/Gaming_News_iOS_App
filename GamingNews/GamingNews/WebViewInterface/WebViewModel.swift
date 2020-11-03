//
//  WebViewModel.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 06/08/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation
import AlamofireRSSParser

class WebViewModel {
    private var article: RSSItem
    var request: URLRequest?

    func getUrl() {
        guard let urlString = article.link,
        let url = URL(string: urlString) else { return }
        request = URLRequest(url: url)
    }

    init(article: RSSItem) {
        self.article = article
    }
}

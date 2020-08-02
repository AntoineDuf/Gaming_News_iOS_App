//
//  Sources.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 01/08/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation

struct Sources {
    let rss_link: String
    let thematics_id: Int
    let documentId: String
    
    init(rss_link: String, thematics_id: Int, documentId: String) {
        self.rss_link = rss_link
        self.thematics_id = thematics_id
        self.documentId = documentId
    }
}


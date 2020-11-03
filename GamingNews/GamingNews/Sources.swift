//
//  Sources.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 01/08/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation

struct Sources {
    let rssLink: String
    let thematicsId: Int
    let documentId: String
    let name: String

    init(rssLink: String, thematicsId: Int, documentId: String, name: String) {
        self.rssLink = rssLink
        self.thematicsId = thematicsId
        self.documentId = documentId
        self.name = name
    }
}

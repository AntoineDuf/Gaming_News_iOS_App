//
//  Tehmatic.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 25/07/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation

struct Thematic {
    let id: Int
    let name: String
    let documentId: String
    
    init(id: Int, name: String, documentId: String) {
        self.id = id
        self.name = name
        self.documentId = documentId
    }
}

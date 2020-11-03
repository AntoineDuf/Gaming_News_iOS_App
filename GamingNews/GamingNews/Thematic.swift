//
//  Tehmatic.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 25/07/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//
//swiftlint:disable identifier_name

import Foundation

struct Thematic {
    let id: Int
    let imageName: String
    let name: String
    let documentId: String

    init(id: Int, imageName: String, name: String, documentId: String) {
        self.id = id
        self.imageName = imageName
        self.name = name
        self.documentId = documentId
    }
}

extension Thematic: Equatable {
    static func == (lhs: Thematic, rhs: Thematic) -> Bool {
        return lhs.id == rhs.id
    }
}

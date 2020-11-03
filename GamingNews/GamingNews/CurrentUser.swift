//
//  CurrentUser.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 17/09/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation

struct CurrentUser {
    let token: String
    let thematicsArray: Int

    init(token: String, thematicsArray: Int) {
        self.token = token
        self.thematicsArray = thematicsArray
    }
}

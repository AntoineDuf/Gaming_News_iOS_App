//
//  ThematicCollectionCell.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 25/07/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation
import UIKit
import FirebaseUI


class ThematicCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var imageCell: UIImageView!
    
    func configureCell(thematic: Thematic) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let reference = storageReference.child("\(thematic.name)")
        imageCell.sd_setImage(with: reference)
    }
}

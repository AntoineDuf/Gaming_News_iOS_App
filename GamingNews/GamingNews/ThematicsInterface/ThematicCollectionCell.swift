//
//  ThematicCollectionCell.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 25/07/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit
import FirebaseUI

class ThematicCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var imageCell: UIImageView!

    override func awakeFromNib() {
         configureStyleCell()
     }

    func configureCell(thematic: Thematic) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let reference = storageReference.child("\(thematic.imageName)")
        imageCell.sd_setImage(with: reference)
    }

     private func configureStyleCell() {
         self.layer.cornerRadius = 8
     }
}

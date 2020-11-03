//
//  ConfigureTableCell.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 10/09/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit
import FirebaseUI

class ConfigureTableCell: UITableViewCell {
    @IBOutlet weak var labelCell: UILabel!

    func configureCell(thematic: Thematic) {
        labelCell.text = thematic.name
    }

    func selectOrDeselectCell(isSelected: Bool) {
        if isSelected {
            accessoryType = .checkmark
        } else {
            accessoryType = .none
        }
    }

}

//
//  ThematicTableCell.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 25/11/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseFirestore

final class ThematicsTableCell: UITableViewCell {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var plusButton: UIButton!

    private var thematics: [Thematic] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    private var selectedThematics: [Thematic] = [] {
        didSet {
            DispatchQueue.main.async {
//                self.collectionView.reloadData()
            }
        }
    }
    var didSelectRow: (_ selectedThematics: [Thematic]) -> Void = {_ in }

    override func awakeFromNib() {
        super.awakeFromNib()
        plusButton.layer.cornerRadius = 8
        plusButton.layer.borderWidth = 2
        plusButton.layer.borderColor = UIColor.systemGreen.cgColor
    }

    func fill(with thematics: [Thematic], and favoriteThematics: [Thematic]) {
        self.thematics = thematics
        self.selectedThematics = favoriteThematics
    }
}

extension ThematicsTableCell: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        print(thematics.count)
        return thematics.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let selectedThematic = thematics[indexPath.row]
        if selectedThematics.contains(selectedThematic) {
            selectedThematics = selectedThematics.filter({ thematic -> Bool in
                return thematic != selectedThematic
            })
        } else {
            selectedThematics.append(selectedThematic)
        }
        didSelectRow(selectedThematics)
    }
}

extension ThematicsTableCell: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(ThematicCell.self)",
            for: indexPath
            ) as? ThematicCell else { fatalError() }
        let thematic = thematics[indexPath.row]
        if selectedThematics.contains(thematic) {
            cell.displaySelection = true
        } else {
            cell.displaySelection = false
        }
        cell.configureCell(thematic: thematic)
        return cell
    }
}

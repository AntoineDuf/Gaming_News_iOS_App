//
//  ThematicCollectionViewController.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 02/07/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit

final class ThematicCollectionViewController: UICollectionViewController {
    
    private var viewModel = ThematicViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        viewModel.getThematics()
        configureCellSize()
    }
}

extension ThematicCollectionViewController {
    // MARK: - Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let RSSFeedVC = segue.destination as? RSSFeedViewController {
            RSSFeedVC.viewModel = RSSFeedViewModel()
        }
    }
}

extension ThematicCollectionViewController {
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        print(viewModel.thematics.count)
        return viewModel.thematics.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(ThematicCollectionCell.self)",
            for: indexPath
            ) as? ThematicCollectionCell else { fatalError() }
        
        let thematic = viewModel.thematics[indexPath.row]
        cell.configureCell(thematic: thematic)
        return cell
    }
}

extension ThematicCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showRSSFeed", sender: nil)
    }
}

private extension ThematicCollectionViewController {
    func configureViewModel() {
        viewModel.thematicHandler = { [weak self] in
            guard let me = self else { return }
            DispatchQueue.main.async {
                me.collectionView.reloadData()
            }
        }
    }
}

    // MARK: - Extension allowing to configure cell design.
private extension ThematicCollectionViewController {
    func configureCellSize() {
        let width = (view.frame.width - 40) / 3
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            else { return }
        layout.itemSize = CGSize(width: width, height: width)
    }
}

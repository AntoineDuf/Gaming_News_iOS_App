//
//  ThematicCollectionViewController.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 02/07/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//
//swiftlint:disable identifier_name

import UIKit

final class ThematicCollectionViewController: UICollectionViewController {

    private let viewModel = ThematicViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        viewModel.getThematics()
        configureCellSize()
    }
}

extension ThematicCollectionViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let RSSFeedVC = segue.destination as? RSSFeedViewController {
            RSSFeedVC.viewModel = RSSFeedViewModel(thematiqueID: viewModel.thematiqueID, thematic: viewModel.thematic!)
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
        viewModel.thematiqueID = indexPath.row
        viewModel.thematic = viewModel.thematics[indexPath.row]
        performSegue(withIdentifier: StoryboardSegue.Thematic.showRSSFeed.rawValue, sender: nil)
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

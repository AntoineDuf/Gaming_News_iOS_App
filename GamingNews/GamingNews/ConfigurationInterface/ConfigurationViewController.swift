//
//  ConfigurationViewController.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 10/09/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//
//swiftlint:disable identifier_name

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ConfigurationViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    private let viewModel = ConfigurationViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        configureViewModel()
        viewModel.getThematics()
        viewModel.getFavoritesThematics()
    }
}

extension ConfigurationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.thematics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(ConfigureTableCell.self)",
            //renommer en ConfigurationCell
            for: indexPath
            ) as? ConfigureTableCell else { fatalError() }
        let thematic = viewModel.thematics[indexPath.row]
        let isSelected = viewModel.favoriteThematics.contains(viewModel.thematics[indexPath.row])
        // dans viewmodel
        cell.selectOrDeselectCell(isSelected: isSelected)
        cell.configureCell(thematic: thematic)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ConfigureTableCell else { return }
        viewModel.didSelectRow(at: indexPath)
        let isRowSelected = viewModel.favoriteThematics.contains(viewModel.thematics[indexPath.row])
        cell.selectOrDeselectCell(isSelected: isRowSelected)
    }
}

private extension ConfigurationViewController {
    func configureViewModel() {
        viewModel.thematicHandler = { [weak self] in
            guard let me = self else { return }
            DispatchQueue.main.async {
                me.tableView.reloadData()
            }
        }
        viewModel.selectedHandler = { [weak self] in
            guard let me = self else { return }
            DispatchQueue.main.async {
                me.tableView.reloadData()
            }
        }
    }
}

// MARK: - Extension allowing to configure cell design.
private extension ConfigurationViewController {
    @IBAction func saveButton(_ sender: Any) {
        viewModel.saveUserInfo()
    }
}

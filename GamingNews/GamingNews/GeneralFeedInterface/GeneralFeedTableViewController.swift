//
//  GeneralFeedTableViewController.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 22/10/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//
//swiftlint:disable identifier_name

import UIKit

class GeneralFeedTableViewController: UITableViewController {
    private let viewModel = GeneralFeedViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        viewModel.getThematicIDs()
    }
}

private extension GeneralFeedTableViewController {
    func configureViewModel() {
        viewModel.articleHandler = { [weak self] in
            guard let me = self else { return }
            me.performSegue(withIdentifier: StoryboardSegue.RSSFeedStoryboard.showWebView.rawValue, sender: nil)
        }
        viewModel.articlesHandler = { [weak self] in
            guard let me = self else { return }
            me.tableView.reloadData()
        }
    }
}

extension GeneralFeedTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let webVC = segue.destination as? WebViewController,
            let article = viewModel.selectedArticle {
            webVC.viewModel = WebViewModel(article: article)
        }
    }
}

extension GeneralFeedTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(GeneralFeedCell.self)",
            for: indexPath
            ) as? GeneralFeedCell else { fatalError() }
        let article = viewModel.articles[indexPath.row]
        cell.configureCell(article: article)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.viewModel.didSelectArticle(at: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.frame.height / 6)
    }
}
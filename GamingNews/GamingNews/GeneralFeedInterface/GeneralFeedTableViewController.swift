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
        configurePullToRefresh()
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
            me.refreshControl?.endRefreshing()
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.tablesViewSection.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.tablesViewSection[section].headerTitle
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tablesViewSection[section].items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(GeneralFeedCell.self)",
            for: indexPath
            ) as? GeneralFeedCell else { fatalError() }
//        let article = viewModel.articles[indexPath.row]
        let article = viewModel.tablesViewSection[indexPath.section].items[indexPath.row]
        cell.configureCell(article: article)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.viewModel.didSelectArticle(at: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

private extension GeneralFeedTableViewController {
    func configurePullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(refreshArticles),
            for: .valueChanged
        )
        self.refreshControl = refreshControl
    }

    @objc func refreshArticles() {
        viewModel.getThematicIDs()
    }
}

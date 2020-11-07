//
//  RSSFeedViewController.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 01/08/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//
//swiftlint:disable identifier_name

import UIKit

class RSSFeedViewController: UITableViewController {
    var viewModel: RSSFeedViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configurePullToRefresh()
        DispatchQueue.main.async {
            self.viewModel.getRSSLinks()
        }
    }
}

extension RSSFeedViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let webVC = segue.destination as? WebViewController,
            let article = viewModel.selectedArticle {
            webVC.viewModel = WebViewModel(article: article)
        }
    }
}

extension RSSFeedViewController {
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
            withIdentifier: "\(ArticleTableViewCell.self)",
            for: indexPath
            ) as? ArticleTableViewCell else { fatalError() }
        let article = viewModel.tablesViewSection[indexPath.section].items[indexPath.row]
        cell.configureCell(article: article, thematic: viewModel.thematic)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.viewModel.didSelectArticle(at: indexPath)
        }
    }
}

private extension RSSFeedViewController {
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

private extension RSSFeedViewController {
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
        viewModel.getRSSLinks()
    }
}

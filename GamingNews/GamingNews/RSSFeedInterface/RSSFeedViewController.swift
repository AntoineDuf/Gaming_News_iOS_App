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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(ArticleTableViewCell.self)",
            for: indexPath
            ) as? ArticleTableViewCell else { fatalError() }
        let article = viewModel.articles[indexPath.row]
        cell.configureCell(article: article, thematic: viewModel.thematic)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.frame.height / 6)
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
        }
    }
}

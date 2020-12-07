//
//  NewsViewController.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 17/11/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//
//swiftlint:disable identifier_name

import UIKit

class NewsViewController: UIViewController {

    private let viewModel = NewsViewModel()

    @IBOutlet weak var articleTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        viewModel.allThematicsIDs = [ 0, 1, 2]
        viewModel.getThematics()
        configurePullToRefresh()
        viewModel.getArticles()
    }
}

private extension NewsViewController {
    func configureViewModel() {
        viewModel.articleHandler = { [weak self] in
            guard let me = self else { return }
            me.performSegue(withIdentifier: StoryboardSegue.NewsInterface.showWebView.rawValue, sender: nil)
        }
        viewModel.articlesHandler = { [weak self] in
            guard let me = self else { return }
            me.articleTableView.reloadData()
            me.articleTableView.refreshControl?.endRefreshing()
        }
    }
}

extension NewsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let webVC = segue.destination as? WebViewController,
            let article = viewModel.selectedArticle {
            webVC.viewModel = WebViewModel(article: article)
        }
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.articleSections.count + 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else if section == 1 {
            return 20
        } else {
            return 40
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else {
            return viewModel.articleSections[section - 1].headerTitle
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel.articleSections[section - 1].items.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0,
            indexPath.section == 0,
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "\(ThematicsTableCell.self)",
                for: indexPath
                ) as? ThematicsTableCell {
            cell.removeSectionSeparators()
            cell.fill(with: viewModel.thematics, and: viewModel.favoriteThematics)
            cell.didSelectRow = { selectedThematics in
                self.viewModel.configureThematicsToDisplay(selectedThematics: selectedThematics)
                //                cell.selectedCells.append(indexPath.row)
            }
            return cell
        } else if let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(NewsCell.self)",
            for: indexPath
            ) as? NewsCell {
            let article = viewModel.articleSections[indexPath.section - 1].items[indexPath.row]
            cell.configureCell(article: article)
            return cell
        }
        fatalError()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.viewModel.didSelectArticle(at: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

private extension NewsViewController {
    func configurePullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(refreshArticles),
            for: .valueChanged
        )
        self.articleTableView.refreshControl = refreshControl
    }

    @objc func refreshArticles() {
        viewModel.getArticles()
    }
}

extension UITableViewCell {
    func removeSectionSeparators() {
        for subview in subviews {
            if subview != contentView && subview.frame.width == frame.width {
                subview.removeFromSuperview()
            }
        }
    }
}

//
//  RSSFeedViewModel.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 01/08/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation
import FirebaseFirestore
import AlamofireRSSParser

class RSSFeedViewModel {
    private var thematiqueID: Int
    var thematic: Thematic
    var articles: [RSSItem] = []
    var tablesViewSection: [RSSArticleByDay] = []
    private var sources: [Sources] = []
    var selectedArticle: RSSItem?
    var articleHandler: () -> Void = {}
    var articlesHandler: () -> Void = {}
    private var sourcesCollection: CollectionReference = Firestore.firestore().collection(L10n.sourcesDB)
    private var rssRequest = AlamofireNetworkRequest()

    init(thematiqueID: Int, thematic: Thematic) {
        self.thematiqueID = thematiqueID
        self.thematic = thematic
    }

    func didSelectArticle(at indexPath: IndexPath) {
        let index = indexPath.row
        self.selectedArticle = articles[index]
        articleHandler()
    }

    func getRSSLinks() {
        sourcesCollection.whereField(
            L10n.thematicsAttribute,
            isEqualTo: thematiqueID
        ).getDocuments { (snapshot, error) in
            if let error = error {
                debugPrint("\(error)")
            } else {
                guard let snap = snapshot else { return }
                for document in snap.documents {
                    let data = document.data()
                    let rssSources = data[L10n.rssAttribute] as? String ?? L10n.errorAttribute
                    let thematicId = data[L10n.thematicsAttribute] as? Int ?? 0
                    let name = data[L10n.nameAttribute] as? String ?? L10n.errorAttribute
                    let documentId = document.documentID
                    let newSource = Sources(
                        rssLink: rssSources,
                        thematicsId: thematicId,
                        documentId: documentId,
                        name: name
                    )
                    self.sources.append(newSource)
                }
                self.getRSSArticles()
            }
        }
    }

    private func getRSSArticles() {
        for source in sources {
            let rssLink = source.rssLink
            guard let rssLinkURL = URL(string: rssLink) else { return }
            rssRequest.get(rssLinkURL) { (response) in
                for item in response {
                    item.source = source.name
                    self.articles.append(item)
                }
                self.articles = self.articles.sorted(by: {
                    $0.pubDate!.compare($1.pubDate!) == .orderedDescending
                })
                self.dispatchRssArticleByParutionDay()
            }
        }
    }
}

extension RSSFeedViewModel {

    func dispatchRssArticleByParutionDay() {
        var firstSection = RSSArticleByDay(order: 0, headerTitle: "Aujourd'hui")
        var secondSection = RSSArticleByDay(order: 1, headerTitle: "Hier")
        var thirdSection = RSSArticleByDay(order: 2, headerTitle: "Il y a deux jours")
        var forthSection = RSSArticleByDay(order: 3, headerTitle: "Il y a trois jours")
        var fifthSection = RSSArticleByDay(order: 4, headerTitle: "Il y a plus de trois jours")

        for article in articles {
            var calendar = NSCalendar.autoupdatingCurrent
            calendar.timeZone = NSTimeZone.system
            if let startDate = article.pubDate {
                let components = calendar.dateComponents(
                    [.day],
                    from: startDate,
                    to: NSDate() as Date
                )
                if let day = components.day {
                    if day < 1 {
                        firstSection.items.append(article)
                    } else if day < 2 {
                        secondSection.items.append(article)
                    } else if day < 3 {
                        thirdSection.items.append(article)
                    } else if day < 4 {
                        forthSection.items.append(article)
                    } else {
                        fifthSection.items.append(article)
                    }
                }
            }
        }
        firstSection.sortItems()
        secondSection.sortItems()
        thirdSection.sortItems()
        forthSection.sortItems()
        fifthSection.sortItems()
        self.tablesViewSection.append(firstSection)
        self.tablesViewSection.append(secondSection)
        self.tablesViewSection.append(thirdSection)
        self.tablesViewSection.append(forthSection)
        self.tablesViewSection.append(fifthSection)
        self.articlesHandler()
    }
}

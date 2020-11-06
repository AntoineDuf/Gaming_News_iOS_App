//
//  GeneralFeedViewModel.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 22/10/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation
import FirebaseFirestore
import AlamofireRSSParser

class GeneralFeedViewModel {

    private var thematiqueID = [Int?]()
    private var sources: [Sources] = []
    var articles: [RSSItem] = []
    var tablesViewSection: [RSSArticleByDay] = []
    var selectedArticle: RSSItem?
    private var sourcesCollection: CollectionReference = Firestore.firestore().collection(L10n.sourcesDB)
    private var rssRequest = AlamofireNetworkRequest()
    var articlesHandler: () -> Void = {}
    var articleHandler: () -> Void = {}

    func didSelectArticle(at indexPath: IndexPath) {
        let index = indexPath.row
        self.selectedArticle = articles[index]
        articleHandler()
    }

    func getThematicIDs() {
        thematiqueID = [0, 1, 2]
        getRSSLinks()
    }

    private func getRSSLinks() {
        let myGroup = DispatchGroup()
        for thematic in self.thematiqueID {
            myGroup.enter()
            self.sourcesCollection.whereField(
                L10n.thematicsAttribute,
                isEqualTo: thematic
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
                }
                myGroup.leave()
            }
        }
        myGroup.notify(queue: .main) {
            self.getRSSArticles()
        }
    }

    private func getRSSArticles() {
        let myGroup = DispatchGroup()
        for source in sources {
            myGroup.enter()
            let rssLink = source.rssLink
            guard let rssLinkURL = URL(string: rssLink) else { return }
            rssRequest.get(rssLinkURL) { (response) in
                for item in response {
                    item.source = source.name
                    self.articles.append(item)
                }
                myGroup.leave()
            }
        }
        myGroup.notify(queue: .main) {
//            self.articles = self.articles.sorted(by: {
//                $0.pubDate!.compare($1.pubDate!) == .orderedDescending
//            })
            var alreadyThere = Set<RSSItem>()
            self.articles = self.articles.compactMap { (rssItem) -> RSSItem? in
                guard !alreadyThere.contains(rssItem) else { return nil }
                alreadyThere.insert(rssItem)
                return rssItem
            }
            self.dispatchRssArticleByParutionDay()
//            self.articlesHandler()
        }
    }
}

extension GeneralFeedViewModel {

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
        firstSection.items = firstSection.items.sorted(by: {
            $0.pubDate!.compare($1.pubDate!) == .orderedDescending
        })
        secondSection.items = secondSection.items.sorted(by: {
            $0.pubDate!.compare($1.pubDate!) == .orderedDescending
        })
        thirdSection.items = thirdSection.items.sorted(by: {
            $0.pubDate!.compare($1.pubDate!) == .orderedDescending
        })
        forthSection.items = forthSection.items.sorted(by: {
            $0.pubDate!.compare($1.pubDate!) == .orderedDescending
        })
        fifthSection.items = fifthSection.items.sorted(by: {
            $0.pubDate!.compare($1.pubDate!) == .orderedDescending
        })
        self.tablesViewSection.append(firstSection)
        self.tablesViewSection.append(secondSection)
        self.tablesViewSection.append(thirdSection)
        self.tablesViewSection.append(forthSection)
        self.tablesViewSection.append(fifthSection)
        self.articlesHandler()
    }
}

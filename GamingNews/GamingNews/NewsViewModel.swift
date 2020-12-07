//
//  NewsViewModel.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 17/11/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation
import FirebaseFirestore
import AlamofireRSSParser

class NewsViewModel {

    var thematics: [Thematic] = []
    var favoriteThematics: [Thematic] = []
    var allThematicsIDs: [Int] = []

    private var sources: [Sources] = []

    private var articles: [RSSItem] = []
    var selectedArticle: RSSItem?
    var articleSections: [RSSArticleByDay] = []

    private var rssRequest = AlamofireNetworkRequest()
    
//    init pour mocker les donner
    private let thematicsFirebaseCollection: CollectionReference = Firestore.firestore().collection(L10n.thematicsDB)
    private let sourcesFirebaseCollection: CollectionReference = Firestore.firestore().collection(L10n.sourcesDB)
//
    var articlesHandler: () -> Void = {}
    var articleHandler: () -> Void = {}

    func didSelectArticle(at indexPath: IndexPath) {
        let index = indexPath.row
        self.selectedArticle = articles[index]
        articleHandler()
    }

    func getArticles() {
        getRSSSources()
    }

    func configureThematicsToDisplay(selectedThematics: [Thematic]) {
        allThematicsIDs.removeAll()
        sources.removeAll()
        articleSections.removeAll()
        articles.removeAll()
        self.favoriteThematics = selectedThematics
        for thematic in favoriteThematics {
            allThematicsIDs.append(Int(thematic.id))
        }
        getRSSSources()
    }

    private func getRSSSources() {
        let myGroup = DispatchGroup()
        for thematicID in self.allThematicsIDs {
            myGroup.enter()
            self.sourcesFirebaseCollection.whereField(
                L10n.thematicsAttribute,
                isEqualTo: thematicID
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
            var alreadyThere = Set<RSSItem>()
            self.articles = self.articles.compactMap { (rssItem) -> RSSItem? in
                guard !alreadyThere.contains(rssItem) else { return nil }
                alreadyThere.insert(rssItem)
                return rssItem
            }
            self.dispatchRssArticleByParutionDay()
        }
    }
}

extension NewsViewModel {

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
        self.articleSections.append(firstSection)
        self.articleSections.append(secondSection)
        self.articleSections.append(thirdSection)
        self.articleSections.append(forthSection)
        self.articleSections.append(fifthSection)
        self.articlesHandler()
    }
}

extension NewsViewModel {
    func getThematics() {
        thematicsFirebaseCollection.getDocuments { (snapshot, error) in
            if let error = error {
                debugPrint("\(error)")
            } else {
                guard let snap = snapshot else { return }
                for document in snap.documents {
                    let data = document.data()
                    let identifier = data[L10n.idAttribute] as? Int ?? 0
                    let imageName = data["image_name"] as? String ?? L10n.errorAttribute
                    let name = data[L10n.nameAttribute] as? String ?? L10n.errorAttribute
                    let documentId = document.documentID
                    let newThematic = Thematic(id: identifier, imageName: imageName, name: name, documentId: documentId)
                    self.thematics.append(newThematic)
                }
            }
        }
    }
}

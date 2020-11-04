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
            self.articles = self.articles.sorted(by: {
                $0.pubDate!.compare($1.pubDate!) == .orderedDescending
            })
            var alreadyThere = Set<RSSItem>()
            self.articles = self.articles.compactMap { (rssItem) -> RSSItem? in
                guard !alreadyThere.contains(rssItem) else { return nil }
                alreadyThere.insert(rssItem)
                return rssItem
            }
            self.articlesHandler()
        }
    }
}

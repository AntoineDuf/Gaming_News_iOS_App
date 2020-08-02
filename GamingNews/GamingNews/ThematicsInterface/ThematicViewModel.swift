//
//  ThematicViewModel.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 25/07/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation
import FirebaseFirestore
import AlamofireRSSParser

class ThematicViewModel {
    var thematics: [Thematic] = []
    var sources: [Sources] = []
    var articles: [RSSItem] = []
    var thematicHandler: () -> Void = {}
    var articlesHandler: () -> Void = {}
    private var thematicsCollection: CollectionReference = Firestore.firestore().collection("thematics")
    private var sourcesCollection: CollectionReference = Firestore.firestore().collection("sources")
    private var rssRequest = AlamofireNetworkRequest()
    
    func getThematics() {
        thematicsCollection.getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("error fetching docs: \(err)")
            } else {
                guard let snap = snapshot else { return }
                for document in snap.documents {
                    let data = document.data()
                    let identifier = data["id"] as? Int ?? 0
                    let name = data["name"] as? String ?? "unknow"
                    let documentId = document.documentID
                    
                    let newThematic = Thematic(id: identifier, name: name, documentId: documentId)
                    
                    self.thematics.append(newThematic)
                }
                self.thematicHandler()
            }
        }
    }

    func getRSSLinks() {
        sourcesCollection.whereField("thematics_id", isEqualTo: 1).getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("error fetching docs: \(err)")
            } else {
                guard let snap = snapshot else { return }
                for document in snap.documents {
                    let data = document.data()
                    let rssSources = data["rss_link"] as? String ?? "unknow"
                    let thematic_id = data["thematics_id"] as? Int ?? 0
                    let documentId = document.documentID
                    
                    let newSource = Sources(rss_link: rssSources, thematics_id: thematic_id, documentId: documentId)
                    
                    self.sources.append(newSource)
                }
                self.getRSSArticles()
            }
        }
    }

    func getRSSArticles() {
        rssRequest.get(URL(string: sources[0].rss_link)!) { (response) in
            for item in response {
                self.articles.append(item)
                self.articlesHandler()
            }
        }
    }
}



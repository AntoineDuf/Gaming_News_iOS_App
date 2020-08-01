//
//  ThematicViewModel.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 25/07/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ThematicViewModel {
    var thematics: [Thematic] = []
    var thematicHandler: () -> Void = {}
    private var thematicsCollection: CollectionReference = Firestore.firestore().collection("thematics")
    
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
}



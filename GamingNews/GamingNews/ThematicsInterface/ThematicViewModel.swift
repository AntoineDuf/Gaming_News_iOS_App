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
    var thematic: Thematic?
    var thematicHandler: () -> Void = {}
    var thematiqueID: Int = 0
    private let thematicsCollection: CollectionReference = Firestore.firestore().collection(L10n.thematicsDB)

    func getThematics() {
        thematicsCollection.getDocuments { (snapshot, error) in
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
                self.thematicHandler()
            }
        }
    }
}

//
//  ConfigurationViewModel.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 10/09/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

final class ConfigurationViewModel {
    private(set) var thematics = [Thematic]()
    private(set) var favoriteThematics = [Thematic]() {
        didSet {
            selectedHandler()
        }
    }
    var thematicHandler: () -> Void = {}
    var selectedHandler: () -> Void = {}
    private let thematicNetworkClient: CollectionReference

    init(thematicNetworkClient: CollectionReference = Firestore.firestore().collection(L10n.thematicsDB)) {
        self.thematicNetworkClient = thematicNetworkClient
    }

    func getThematics() {
        thematicNetworkClient.getDocuments { (snapshot, error) in
            if let error = error {
                //errorHandler
                debugPrint("\(error)")
            } else {
                guard let snap = snapshot else { return }
                for document in snap.documents {
                    //Codable
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

    func getFavoritesThematics() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").observeSingleEvent(of: .value, with: { (datasnaphost) in
            //Decodable
            let value = datasnaphost.value as? NSDictionary
            let usernameValues = value?[userID] as? [Int] ?? []
            self.favoriteThematics = usernameValues.compactMap { (thematicID) -> Thematic in
                return self.thematics[thematicID]
            }
        } ) { (error) in
            print(error)
        }
    }

    func saveUserInfo() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        var favoriteThemacticsId: [Int] = []
        for thematic in favoriteThematics {
            favoriteThemacticsId.append(thematic.id)
        }
        let userValues = [userID: favoriteThemacticsId]
        Database.database().reference().child("users").setValue(userValues as [AnyHashable : Any]) { (
            error,
            reference
            ) in
            if let error = error {
                print(error)
                return
            }
        }
    }

    func didSelectRow(at indexPath: IndexPath) {
        let index = indexPath.row
        let isThematicAlreadySelected = favoriteThematics.contains(thematics[index])
        if isThematicAlreadySelected {
            favoriteThematics = favoriteThematics.filter { thematicSelectedIndex -> Bool in
                return thematicSelectedIndex != thematics[index]
            }
        } else {
            favoriteThematics.append(thematics[index])
        }
    }
}

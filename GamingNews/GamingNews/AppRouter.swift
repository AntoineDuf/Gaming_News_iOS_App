//
//  AppRouter.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 10/09/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

final class AppRouter {
    static let shared = AppRouter()
    var tabBarItemIndex = 0
    var usernameThematics = [Int]()

    private lazy var authentificationVC: UIViewController = {
        let identifier = "\(AuthentificationViewController.self)"
        return makeAuthentificationVC(with: identifier, from: "Authentification")
    }()

    lazy var tabBarVC: UITabBarController = {
        let identifier = "\(TabBarController.self)"
        return makeTabBarVC(with: identifier, from: "TabBar")
    }()

    func makeAuthentificationVC(with identifier: String, from storyboardName: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }

    func makeTabBarVC(with identifier: String, from storyboardName: String) -> UITabBarController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier) as! TabBarController
        vc.viewModel = TabBarViewModel()
        vc.viewModel.selectedItem = tabBarItemIndex
        return vc
    }

    func makeFirstVC() -> UIViewController {
        if isUserAlreadyConnected {
            tabBarItemIndex = 0
            DispatchQueue.main.async {
                self.ifUserIsConfigured() { success in
                    if success == true {
                        self.tabBarItemIndex = 0
                    }
                }
            }
            return tabBarVC
        } else {
            //GO TO SIGNUP
            return tabBarVC
        }
    }
}

private extension AppRouter {
    var isUserAlreadyConnected: Bool {
        // Handle if user is already connect to Google.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        if GIDSignIn.sharedInstance()?.currentUser != nil {
            // User is already connected.
            return true
        }
        // User is not connected to Google.
        return false
    }

//    func getUserInfo() {
//        let userID = Auth.auth().currentUser?.uid
//        Database.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshot) in
//          // Get user value
//          let value = snapshot.value as? NSDictionary
//            let username = value?[userID as Any] as? [Int] ?? [0]
//            self.usernameThematics = username
//          }) { (error) in
//            print(error.localizedDescription)
//        }
//    }

    func ifUserIsConfigured(completionHandler: @escaping ((_ succes : Bool) -> Void)) {
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        let userId = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?[userId as Any] as? [Int] ?? [0]
            if username.isEmpty {
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        })
    }
}

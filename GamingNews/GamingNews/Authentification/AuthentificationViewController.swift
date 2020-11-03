//
//  AuthentificationViewController.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 28/08/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import Firebase

final class AuthentificationViewController: UIViewController {
    @IBOutlet weak var faceBookSignInView: UIView!
    @IBOutlet var googleSignInButton: GIDSignInButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        let loginButton = FBLoginButton()
        loginButton.center = faceBookSignInView.center
        faceBookSignInView.addSubview(loginButton)
    }
}

private extension AuthentificationViewController {
    @IBAction func googleSignButton(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
}

extension AuthentificationViewController {
//        func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//            if let error = error {
//                print(error.localizedDescription)
//            }
//                guard let authentication = user.authentication else { return }
//                let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
//            Auth.auth().signIn(with: credential) { (authResult, error) in
//                if let error = error {
//                    print(error)
//                } else {
//                    let storyboard = UIStoryboard(name: "Configuration", bundle: nil)
//                    let configurationVC = storyboard.instantiateViewController(
//                        withIdentifier: "\(ConfigurationViewController.self)"
//                    )
//                    configurationVC.modalPresentationStyle = .fullScreen
//                    self.present(configurationVC, animated: false, completion: nil)
//                }
//        }
//}
}

//extension AuthentificationViewController: FBSDKLoginKit.LoginButtonDelegate {
//    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
//        if error == nil {
//            guard let tokenString = AccessToken.current?.tokenString else {
//                return
//            }
//            let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
//            Auth.auth().signIn(with: credential) { (authDataResult, error) in
//                if let error = error {
//                    print(error.localizedDescription)
//                    //Gestion des erreur
//                    return
//                }
//                print(authDataResult?.user.email as Any)
//                let storyboard = UIStoryboard(name: "Configuration", bundle: nil)
//                let configurationVC = storyboard.instantiateViewController(withIdentifier: "\(ConfigurationViewController.self)") as! UIViewController
//                self.present(configurationVC, animated: false, completion: nil)
//            }
//        }
//    }

//    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//        return
//    }
//}

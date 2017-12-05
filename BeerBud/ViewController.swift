//
//  ViewController.swift
//  BeerBud
//
//  Created by Daniel Lu on 11/30/17.
//  Copyright © 2017 Daniel Lu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class ViewController: UIViewController {

    var authUI: FUIAuth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUI = FUIAuth.defaultAuthUI()
        authUI.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exploreSegue" {
            let destination = segue.destination as! StyleViewController
            destination.email = (self.authUI.auth?.currentUser?.email)!
        } else if segue.identifier == "favoriteSegue" {
            let destination = segue.destination as! FavoritesViewController
            destination.email = (self.authUI.auth?.currentUser?.email)!
        } else if segue.identifier == "surpriseSegue" {
            let destination = segue.destination as! BeerViewController
            destination.email = (self.authUI.auth?.currentUser?.email)!
            destination.buttonText = "Add to Favorites"
            destination.surpriseEnabled = 1
        } else if segue.identifier == "searchSegue" {
            let destination = segue.destination as! SearchViewController
            destination.email = (self.authUI.auth?.currentUser?.email)!
        }
    }
    
    func signIn() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth()
        ]
        if authUI.auth?.currentUser == nil {
            self.authUI?.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        }
    }
    
    @IBAction func exploreButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func favoritesButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            signIn()
        } catch {
            print("")
        }
    }
    
    @IBAction func surpriseMeButtonPressed(_ sender: UIButton) {
    }
}

extension ViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            print("*** success with user = \(user.email!)")
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        loginViewController.view.backgroundColor = UIColor.white
        let marginInset: CGFloat = 16
        let imageY = self.view.center.y - 225
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInset, y: imageY, width: self.view.frame.width - (marginInset*2), height: 225)
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "beer")
        logoImageView.contentMode = .scaleAspectFit
        loginViewController.view.addSubview(logoImageView)
        return loginViewController
    }
}



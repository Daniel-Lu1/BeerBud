//
//  BeerViewController.swift
//  BeerBud
//
//  Created by Daniel Lu on 12/1/17.
//  Copyright © 2017 Daniel Lu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class BeerViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var abvLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    
    var beerDetail = BeerDetail()
    var email = ""
    var buttonText = ""
    var docID = ""
    var surpriseEnabled = 0
    var db: Firestore!
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "Looking for Beer..."
        favoritesButton.setTitle(buttonText, for: UIControlState.normal)
        db = Firestore.firestore()
        if surpriseEnabled == 1 {
            beerDetail.getRandom() {
                self.surpriseEnabled = 0
                print("*** got random, setting surprisedEnabled back to \(String(self.surpriseEnabled))")
                self.updateUserInterface()
            }
        } else {
            beerDetail.getDetail {
                self.updateUserInterface()
            }
        }
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        if buttonText == "Add to Favorites" {
            let dataToSave: [String: Any] = ["beerName": beerDetail.name, "beerId": beerDetail.id, "postingUserID": email]
            var ref: DocumentReference? = nil
            ref = db.collection("beers").addDocument(data: dataToSave) { (error) in
                if let error = error {
                    print("Error: adding document")
                } else {
                    print("Document added")
                    self.showAlert(title: "Success!", message: "Added \(self.beerDetail.name) to your list of favorites!")
                }
            }
        } else {
            db.collection("beers").document(docID).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    self.showAlert(title: "Success!", message: "Removed \(self.beerDetail.name) from your list of favorites!")
                }
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func updateUserInterface() {
        if beerDetail.name != "" {
          nameLabel.text = "Name: \(beerDetail.name)"
        } else {
            nameLabel.text = "Name: N/A - Check Spelling"
        }
        abvLabel.text = "ABV: \(String(beerDetail.abv))%"
        categoryLabel.text = "Category: \(beerDetail.category)"
        styleLabel.text = "Style: \(beerDetail.style)"
        if beerDetail.description != "" {
            descriptionLabel.text = "Description: \(beerDetail.description)"
        } else {
            descriptionLabel.text = "No description available."
        }
    }
}



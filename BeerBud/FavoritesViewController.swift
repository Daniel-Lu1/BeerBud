//
//  FavoritesViewController.swift
//  BeerBud
//
//  Created by Daniel Lu on 12/2/17.
//  Copyright © 2017 Daniel Lu. All rights reserved.
//

import UIKit
import Firebase

class FavoritesViewController: UIViewController {
    var email = ""
    var db: Firestore!
    
    struct beerData {
        var id = ""
        var name = ""
        var docID = ""
    }
    
    var beerArray = [beerData]()
    
    @IBOutlet weak var favoriteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        loadData()
        checkForUpdates()
    }
    
    func loadData() {
        db.collection("beers").getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR: reading documents")
                return
            }
            self.beerArray = []
            for document in querySnapshot!.documents {
                let documentID = document.documentID
                let docData = document.data()
                let beerID = docData["beerId"] as! String? ?? "" //see if you can cast as string, if nil, set as ""
                let beerName = docData["beerName"] as! String? ?? ""
                let postingUserID = docData["postingUserID"] as! String? ?? ""
                if postingUserID == (self.email) {
                    self.beerArray.append(beerData(id: beerID, name: beerName, docID: documentID))
                }
            }
            self.favoriteTableView.reloadData()
        }
    }
    
    func checkForUpdates() {
        db.collection("beers").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR: adding the snapshot listener")
                return
            }
            self.loadData()
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! BeerViewController
        let selectedRow = favoriteTableView.indexPathForSelectedRow!.row
        destination.buttonText = "Delete from Favorites"
        destination.email = email
        destination.beerDetail.id = beerArray[selectedRow].id
        destination.docID = beerArray[selectedRow].docID
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoriteTableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
        cell.textLabel?.text = beerArray[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        favoriteTableView.deselectRow(at: indexPath, animated: true)
    }
}

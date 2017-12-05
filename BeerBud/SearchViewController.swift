//
//  SearchViewController.swift
//  BeerBud
//
//  Created by Daniel Lu on 12/5/17.
//  Copyright © 2017 Daniel Lu. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var beerTextField: UITextField!
    
    var searchArray = [String]()
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchArray.append(beerTextField.text!)
        tableview.reloadData()
        performSegue(withIdentifier: "searchBeerSegue", sender: nil)
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        searchArray = []
        tableview.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! BeerViewController
        destination.beerDetail.searchEnabled = 1
        destination.beerDetail.name = beerTextField.text!
        destination.email = email
        destination.buttonText = "Add to Favorites"
        destination.beerDetail.description = "Searching for beer... if there is no response in 5 seconds, please check your spelling and try again."
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        cell.textLabel?.text = searchArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        beerTextField.text = searchArray[indexPath.row]
        print(searchArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

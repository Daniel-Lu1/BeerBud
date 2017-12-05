//
//  StyleDetailViewController.swift
//  BeerBud
//
//  Created by Daniel Lu on 12/1/17.
//  Copyright © 2017 Daniel Lu. All rights reserved.
//

import UIKit

class StyleDetailViewController: UIViewController {

    @IBOutlet weak var styleTableView: UITableView!
    
    var styleBeers = StyleBeer()
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleTableView.delegate = self
        styleTableView.dataSource = self
        styleBeers.getBeers {
            self.styleTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! BeerViewController
        if let selectedRow = styleTableView.indexPathForSelectedRow?.row {
            destination.beerDetail.id = styleBeers.styleBeersArray[selectedRow].beerId
            destination.email = email
            destination.buttonText = "Add to Favorites"
        }
    }
}

extension StyleDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return styleBeers.styleBeersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StyleBeerCell", for: indexPath)
        cell.textLabel?.text = styleBeers.styleBeersArray[indexPath.row].name
        if indexPath.row == styleBeers.styleBeersArray.count-1 && styleBeers.currentPage <= styleBeers.totalPages {
            styleBeers.getBeers {
                self.styleTableView.reloadData()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        styleTableView.deselectRow(at: indexPath, animated: true)
    }
}

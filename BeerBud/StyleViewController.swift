//
//  StyleViewController.swift
//  BeerBud
//
//  Created by Daniel Lu on 12/1/17.
//  Copyright © 2017 Daniel Lu. All rights reserved.
//

import UIKit

class StyleViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var categories = Category()
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        categories.getCategories {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! StyleDetailViewController
        if let selectedRow = tableView.indexPathForSelectedRow?.row {
            destination.styleBeers.category = categories.categoriesArray[selectedRow].styleID
            destination.email = self.email
        }
    }
}

extension StyleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.categoriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StyleCell", for: indexPath)
        cell.textLabel?.text = categories.categoriesArray[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

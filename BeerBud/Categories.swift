//
//  Categories.swift
//  BeerBud
//
//  Created by Daniel Lu on 12/1/17.
//  Copyright © 2017 Daniel Lu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Category {
    struct CategoryData {
        var styleID: Int
        var categoryID: Int
        var name: String
    }
    
    //var numberOfSpecies = 0
    var categoryURL = "https://api.brewerydb.com/v2/styles?key=f03117fc41bae0ccc04d870e34656b3d"
    var categoriesArray = [CategoryData]()
    var count = 169
    
    func getCategories(completed: @escaping () -> ()) {
        Alamofire.request(categoryURL).responseJSON {response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for index in 0..<self.count {
                    let name = json["data"][index]["shortName"].stringValue
                    let styleID = json["data"][index]["id"].intValue
                    let categoryID = json["data"][index]["categoryId"].intValue
                    //let url = json["results"][index]["url"].stringValue
                    self.categoriesArray.append(CategoryData(styleID: styleID, categoryID: categoryID, name: name))
                }
            case .failure(let error):
                print("Error receiving JSON: \(error)")
            }
            completed()
        }
    }
}

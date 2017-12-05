//
//  StyleBeer.swift
//  BeerBud
//
//  Created by Daniel Lu on 12/1/17.
//  Copyright © 2017 Daniel Lu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class StyleBeer {
    struct StyleBeerData {
        var name: String
        var styleId = 0
        var beerId: String
    }
    var category: Int = 0
    
    var baseURL: String = "https://api.brewerydb.com/v2/beers?styleId="
    var keyURL: String = "&key=f03117fc41bae0ccc04d870e34656b3d"
    var styleBeersArray = [StyleBeerData]()
    var currentPage = 1
    var totalPages = 0
    
    func getBeers(completed: @escaping () -> ()) {
        let beerStyleURL = baseURL + String(category) + "&p=" + String(currentPage) + keyURL
        print(beerStyleURL)
        Alamofire.request(beerStyleURL).responseJSON {response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.totalPages = json["numberOfPages"].intValue
                self.currentPage += 1
                let count = json["data"].count
                for index in 0..<count {
                    let name = json["data"][index]["name"].stringValue
                    let styleID = json["data"][index]["styleId"].intValue
                    let beerID = json["data"][index]["id"].stringValue
                    //let url = json["results"][index]["url"].stringValue
                    self.styleBeersArray.append(StyleBeerData(name: name, styleId: styleID, beerId: beerID))
                    }
            case .failure(let error):
                print("Error receiving JSON: \(error)")
            }
            completed()
        }
    }
}
    
//    func getOtherBeers(completed: @escaping () -> ()) {
//        for index in self.currentPage...self.totalPages {
//            let beerStyleURL2 = baseURL + String(category) + "&p=" + String(index) + keyURL
//            print(beerStyleURL2)
//            Alamofire.request(beerStyleURL2).responseJSON {response in
//                switch response.result {
//                case .success(let value):
//                    let json = JSON(value)
//                    let count = json["data"].count
//                    for index in 0..<count {
//                        let name = json["data"][index]["name"].stringValue
//                        let styleID = json["data"][index]["styleId"].intValue
//                        let beerID = json["data"][index]["id"].stringValue
//                        //let url = json["results"][index]["url"].stringValue
//                        self.styleBeersArray.append(StyleBeerData(name: name, styleId: styleID, beerId: beerID))
//                    }
//                case .failure(let error):
//                    print("Error receiving JSON: \(error)")
//                }
//            }
//        }
//        print(self.styleBeersArray)
//        completed()
//    }
//}


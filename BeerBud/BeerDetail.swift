//
//  BeerDetail.swift
//  BeerBud
//
//  Created by Daniel Lu on 12/1/17.
//  Copyright © 2017 Daniel Lu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BeerDetail {
    var name = ""
    var abv = 0.0
    var category = ""
    var description = ""
    var style = ""
    var id = ""
    var searchEnabled = 0
    
    var baseURL: String = "https://api.brewerydb.com/v2/beers?ids="
    var keyURL: String = "&key=f03117fc41bae0ccc04d870e34656b3d"
    
    func getDetail(completed: @escaping () -> ()) {
        if searchEnabled == 0 {
            let beerURL = baseURL + id + keyURL
            print(beerURL)
            Alamofire.request(beerURL).responseJSON {response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.name = json["data"][0]["name"].stringValue
                    self.abv = json["data"][0]["abv"].doubleValue
                    self.category = json["data"][0]["style"]["category"]["name"].stringValue
                    self.style = json["data"][0]["style"]["name"].stringValue
                    self.description = json["data"][0]["description"].stringValue
                case .failure(let error):
                    print("Error receiving JSON: \(error)")
                }
                completed()
            }
        } else {
            let nameSeparatedBySpaces = name.replacingOccurrences(of: " ", with: "%20")
            let beerURL = "https://api.brewerydb.com/v2/beers?name=" + nameSeparatedBySpaces + keyURL
            print(beerURL)
            Alamofire.request(beerURL).responseJSON {response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.name = json["data"][0]["name"].stringValue
                    self.abv = json["data"][0]["abv"].doubleValue
                    self.category = json["data"][0]["style"]["category"]["name"].stringValue
                    self.style = json["data"][0]["style"]["name"].stringValue
                    self.description = json["data"][0]["description"].stringValue
                    self.id = json["data"][0]["id"].stringValue
                    self.searchEnabled = 0
                case .failure(let error):
                    print("Error receiving JSON: \(error)")
                }
                completed()
            }
        }
    }
    
    func getRandom(completed: @escaping () -> ()) {
        let randomStyle = Int(arc4random_uniform(UInt32(170)))
        let beerURL = "https://api.brewerydb.com/v2/beers?styleId=" + String(randomStyle) + "&order=random&randomCount=1" + keyURL
        print(beerURL)
        Alamofire.request(beerURL).responseJSON {response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.name = json["data"][0]["name"].stringValue
                self.abv = json["data"][0]["abv"].doubleValue
                self.category = json["data"][0]["style"]["category"]["name"].stringValue
                self.style = json["data"][0]["style"]["name"].stringValue
                self.description = json["data"][0]["description"].stringValue
                self.id = json["data"][0]["id"].stringValue
            case .failure(let error):
                print("Error receiving JSON: \(error)")
            }
            completed()
        }

    }
}

//
//  Event.swift
//  Group3
//
//  Created by Mohammad AbuHannood on 2023-07-08.
//

import Foundation
import FirebaseFirestoreSwift


struct Event: Codable {
    var id: String? = UUID().uuidString
    var title: String = ""
    var lat: Double = 0.0
    var long: Double = 0.0
    var address:String = ""
    var description:String = ""
    var price:Double = 0.0
    var venueName:String = ""
    var date:String = ""
    var performers:String = ""
    init(){
        
    }
    
    init(id: String? = nil, title: String, lat: Double,long: Double, address: String, description: String, price:Double, venueName:String, date:String, performers:String) {
        self.id = id
        self.title = title
        self.long = long
        self.lat = lat
        self.address = address
        self.description = description
        self.price = price
        self.venueName = venueName
        self.date = date
        self.performers = performers
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.long = try container.decode(Double.self, forKey: .long)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.address = try container.decode(String.self, forKey: .address)
        self.description = try container.decode(String.self, forKey: .description)
        self.price = try container.decode(Double.self, forKey: .price)
        self.venueName = try container.decode(String.self, forKey: .venueName)
        self.date = try container.decode(String.self, forKey: .date)
        self.performers = try container.decode(String.self, forKey: .performers)

    }
    
    init?(dictionary: [String:Any]){
        
        guard let title = dictionary["title"] as? String else {
            print("Failed to read title")
            return nil
        }
        
        guard let description = dictionary["description"] as? String else {
            print("Failed to read description")
            return nil
        }
        
        guard let address = dictionary["address"] as? String else {
            print("Failed to read address")
            return nil
        }
        guard let long = dictionary["long"] as? Double else {
            print("Failed to read long")
            return nil
        }
        guard let lat = dictionary["lat"] as? Double else {
            print("Failed to read lat")
            return nil
        }
        guard let price = dictionary["price"] as? Double else {
            print("Failed to read price")
            return nil
        }
        
        guard let venueName = dictionary["venueName"] as? String else {
            print("Failed to read venueName")
            return nil
        }
        
        guard let date = dictionary["date"] as? String else {
            print("Failed to read date")
            return nil
        }
      
        guard let performers = dictionary["performers"] as? String else {
            print("Failed to read performers")
            return nil
        }
        self.init(title: title, lat: lat, long: long, address: address, description: description, price: price, venueName: venueName, date:date, performers: performers)
        
    }
    
    
}

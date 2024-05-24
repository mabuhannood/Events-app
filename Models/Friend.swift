//
//  Friend.swift
//  Group3
//
//

import Foundation
import FirebaseFirestoreSwift


struct Friend: Codable {
    var id: String? = UUID().uuidString
    var name: String = ""
    var email: String = ""
    
    init(){
        
    }
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decode(String.self, forKey: .email)
    }
    
    init?(dictionary: [String:Any]){
        
        guard let name = dictionary["name"] as? String else {
            print("Failed to read name")
            return nil
        }
        
        guard let email = dictionary["email"] as? String else {
            print("Failed to read email")
            return nil
        }
        
        self.init(name: name, email: email)
    }

}

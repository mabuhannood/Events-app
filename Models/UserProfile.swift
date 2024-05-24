//
//  User.swift
//  Group3
//
//  Created by Diya Patel on 2023-06-28.
//

import Foundation
import FirebaseFirestoreSwift


struct UserProfile: Codable {
    var id: String? = UUID().uuidString
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var contactNumber: String = ""
    
    init(){
        
    }
    
    init(name: String, email: String, password: String, contactNumber: String) {
        self.name = name
        self.email = email
        self.password = password
        self.contactNumber = contactNumber
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decode(String.self, forKey: .email)
        self.password = try container.decode(String.self, forKey: .password)
        self.contactNumber = try container.decode(String.self, forKey: .contactNumber)
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
        
        guard let password = dictionary["password"] as? String else {
            print("Failed to read password")
            return nil
        }
        
        guard let contactNumber = dictionary["contactNumber"] as? String else {
            print("Failed to read contactNumber")
            return nil
        }
        
        self.init(name: name, email: email, password: password, contactNumber: contactNumber)
    }

}

//
//  FirestoreController.swift
//  Group3
//
//  Created by Diya Patel on 2023-06-28.
//

import Foundation
import FirebaseFirestore
import Firebase

class UserProfileController : ObservableObject{
    
    
    @Published var userProfile = UserProfile()
    private let store : Firestore
    private static var shared : UserProfileController?
    private let COLLECTION_PROFILE : String = "UserProfile"
        private let FIELD_NAME = "name"
        private let FIELD_EMAIL = "email"
        private let FIELD_CONTACT_NUMBER = "contactNumber"
        private let FIELD_PASSWORD = "password"
    
    // Logged in user's email
    var loggedInUserEmail = Auth.auth().currentUser?.email ?? ""
    
    private let db = Firestore.firestore()
    
    init(store: Firestore) {
        self.store = store
    }
    // Get shared instance of UserProfileController
    static func getInstance() -> UserProfileController?{
        if (shared == nil){
            shared = UserProfileController(store: Firestore.firestore())
        }
        
        return shared
    }
    // Insert user data into Firestore

    func insertUserData(newUserData: UserProfile) {
        print(#function, "Trying to insert \(newUserData.name) to DB")
        print(#function, "current email", loggedInUserEmail)

        loggedInUserEmail = Auth.auth().currentUser?.email ?? ""

        if loggedInUserEmail.isEmpty {
            print("Logged in user not identified")
        } else {
            do {
                let documentRef = self.store.collection(COLLECTION_PROFILE).document(loggedInUserEmail)
                try documentRef.setData(from: newUserData)
            } catch let error as NSError {
                print("Unable to set document data in Firestore: \(error)")
            }
        }
    }

    
    // Get all user data from Firestore


    func getAllUserData(completion: @escaping () -> Void) {
        loggedInUserEmail = Auth.auth().currentUser?.email ?? ""
        
        print(#function, "current email", loggedInUserEmail)
        
        self.store
            .collection(COLLECTION_PROFILE)
            .document(loggedInUserEmail)
            .addSnapshotListener { (documentSnapshot, error) in
                guard let document = documentSnapshot else {
                    print("Unable to retrieve data from Firestore: ", error ?? "")
                    return
                }
                
                if let profileData = document.data().flatMap({ try? Firestore.Decoder().decode(UserProfile.self, from: $0) }) {
                    let docId = document.documentID
                    var userProfile = profileData
                    userProfile.id = docId
                    
                    if document.exists {
                        self.userProfile = userProfile
                        print("Profile data has been retrieved successfully:", userProfile)
                    } else {
                        // Document doesn't exist
                        print("Profile document doesn't exist")
                    }
                } else {
                    print("Error converting document into UserProfile object")
                }
                
                completion()
            }
    }

    // Update user data in Firestore
    func updateUserData(userProfileToUpdate: UserProfile, completion: @escaping (Error?) -> Void) {
        loggedInUserEmail = Auth.auth().currentUser?.email ?? ""
                
        self.store.collection(COLLECTION_PROFILE).document(userProfileToUpdate.id!)
            .updateData(
                [
                    FIELD_NAME : userProfileToUpdate.name,
                    FIELD_CONTACT_NUMBER : userProfileToUpdate.contactNumber,
                    FIELD_PASSWORD : userProfileToUpdate.password,
                    FIELD_EMAIL : userProfileToUpdate.email,
                ]
            ) { error in
                completion(error)
            }
    }
    
    
    func searchUser(name: String, completion: @escaping ([Friend]?, Error?) -> Void) -> ListenerRegistration? {
        let query = self.store.collection(COLLECTION_PROFILE).whereField("name", isEqualTo: name.lowercased())
        
        let listener = query.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print(#function, "Unable to retrieve data from Firestore: \(error)")
                completion(nil, error)
                return
            }
            
            var friendsList: [Friend] = []
            
            for document in querySnapshot!.documents {
                do {
                    var friend: Friend = try document.data(as: Friend.self)
                    friend.id = document.documentID
                    
                    friendsList.append(friend)
                } catch let error {
                    print(#function, "Unable to convert the document into an object: \(error)")
                }
            }
            
            print("friends: \(friendsList.count)")
            completion(friendsList, nil)
        }
        
        return listener
    }


}


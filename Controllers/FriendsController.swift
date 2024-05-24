//
//  FriendsController.swift
//  Group3
//
//  Created by Mohammad AbuHannood on 2023-07-08.
//

import Foundation
import FirebaseFirestore
import Firebase

class FriendsController : ObservableObject{
    
    
    @Published var friendsList = [Friend]()
    private let store : Firestore
    private static var shared : FriendsController?
    private let COLLECTION_FRIENDS_LIST : String = "FriendsList"
    private let COLLECTION_EVENTY : String = "Eventy"
    
    private let db = Firestore.firestore()
    
    var loggedInUserEmail = Auth.auth().currentUser?.email ?? ""
    
    init(store: Firestore) {
        self.store = store
    }
    // Get shared instance of ParkingController
    static func getInstance() -> FriendsController?{
        if (shared == nil){
            shared = FriendsController(store: Firestore.firestore())
        }
        
        return shared
    }
    // Insert parking data into Firestore
    func addFriend(friend : Friend){
        print(loggedInUserEmail)
        if (loggedInUserEmail.isEmpty){
            print(#function, "Logged in user not identified")
        }else{
            do{
                // Add document to the Firestore collection
                try self.store
                    .collection(COLLECTION_EVENTY).document(loggedInUserEmail)
                    .collection(COLLECTION_FRIENDS_LIST)
                    .addDocument(from: friend)
            }catch let error as NSError{
                print(#function, "Unable to add document to firestore : \(error)")
            }
        }
    }
    
    // Get all parking data from Firestore
    func getAllFriends(completion: @escaping ([Friend]?, Error?) -> Void) -> ListenerRegistration? {
        loggedInUserEmail = Auth.auth().currentUser?.email ?? ""
        let listener = self.store.collection(COLLECTION_EVENTY).document(loggedInUserEmail)
            .collection(COLLECTION_FRIENDS_LIST).addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print(#function, "Unable to retrieve data from Firestore : \(error)")
                    completion(nil, error)
                    return
                }
                
                var friendsList: [Friend] = []
                
                querySnapshot?.documents.forEach { document in
                    do {
                        var friend: Friend = try document.data(as: Friend.self)
                        friend.id = document.documentID
                        
                        friendsList.append(friend)
                    } catch let error {
                        print(#function, "Unable to convert the document into object : \(error)")
                    }
                }
                print("friends: \(friendsList.count)")
                completion(friendsList, nil)
            }
        
        return listener
    }
    
    // Delete parking data from Firestore
    func deleteFriends(friendToDelete : Friend){
        loggedInUserEmail = Auth.auth().currentUser?.email ?? ""
        self.store
            .collection(COLLECTION_EVENTY).document(loggedInUserEmail)
            .collection(COLLECTION_FRIENDS_LIST)
            .document(friendToDelete.id!)
            .delete{error in
                
                if let error = error {
                    print(#function, "Unable to delete document : \(error)")
                }else{
                    print(#function, "Successfully deleted \(friendToDelete) from the firestore")
                }
                
            }
    }
    
}


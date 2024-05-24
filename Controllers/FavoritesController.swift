//
//  FavoritesController.swift
//  Group3
//
//  Created by Mohammad AbuHannood on 2023-07-08.
//

import Foundation
import FirebaseFirestore
import Firebase

class FavoritesController : ObservableObject{
    
    
    @Published var favoritesList = [Event]()
    private let store : Firestore
    private static var shared : FavoritesController?
    private let COLLECTION_FAVORITES_LIST : String = "FavoritesList"
    private let COLLECTION_EVENTY : String = "Eventy"
    
    var loggedInUserEmail = Auth.auth().currentUser?.email ?? ""
    
    init(store: Firestore) {
        self.store = store
    }
    // Get shared instance of ParkingController
    static func getInstance() -> FavoritesController?{
        if (shared == nil){
            shared = FavoritesController(store: Firestore.firestore())
        }
        
        return shared
    }
    // Insert parking data into Firestore
    func addEvent(event: Event, completion: @escaping (Error?) -> Void) {
        guard !loggedInUserEmail.isEmpty else {
            print(#function, "Logged in user not identified")
            return
        }
        
        do {
            // Set the document ID to event.id
            try self.store
                .collection(COLLECTION_EVENTY)
                .document(loggedInUserEmail)
                .collection(COLLECTION_FAVORITES_LIST)
                .document(event.id ?? "random_id")
                .setData(from: event) { error in
                    if let error = error {
                        print(#function, "Unable to add document to Firestore: \(error)")
                        completion(error)
                    } else {
                        completion(nil)
                    }
                }
        } catch let error as NSError {
            print(#function, "Unable to add document to Firestore: \(error)")
            completion(error)
        }
    }


    
    // Get all parking data from Firestore
    func getAllFavorites(completion: @escaping ([Event]?, Error?) -> Void) -> ListenerRegistration? {
        loggedInUserEmail = Auth.auth().currentUser?.email ?? ""
        let listener = self.store.collection(COLLECTION_EVENTY).document(loggedInUserEmail)
            .collection(COLLECTION_FAVORITES_LIST).addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print(#function, "Unable to retrieve data from Firestore : \(error)")
                    completion(nil, error)
                    return
                }
                
                var favList: [Event] = []
                
                querySnapshot?.documents.forEach { document in
                    do {
                        var event: Event = try document.data(as: Event.self)
                        event.id = document.documentID
                        
                        favList.append(event)
                    } catch let error {
                        print(#function, "Unable to convert the document into object : \(error)")
                    }
                }
                print("favs: \(favList.count)")
                completion(favList, nil)
            }
        
        return listener
    }
    
    // Delete parking data from Firestore
    func deleteEvent(eventToDelete : Event){
        loggedInUserEmail = Auth.auth().currentUser?.email ?? ""
        self.store
            .collection(COLLECTION_EVENTY).document(loggedInUserEmail)
            .collection(COLLECTION_FAVORITES_LIST)
            .document(eventToDelete.id!)
            .delete{error in
                
                if let error = error {
                    print(#function, "Unable to delete document : \(error)")
                }else{
                    print(#function, "Successfully deleted \(eventToDelete) from the firestore")
                }
                
            }
    }
}


//
//  MyFriendsView.swift
//  Group3
//
//  Created by Diya Patel on 2023-06-29.
//

import SwiftUI

struct MyFriendsView: View {
    @State private var friendsList: [Friend] = []
    @EnvironmentObject var friendsController: FriendsController
    @EnvironmentObject var favoriteController: FavoritesController

    @Environment(\.presentationMode) var presentationMode
    @State private var isEditing = false // Add state variable for edit mode
    
    var body: some View {
        
        VStack {
            // Add edit button and remove all button
            HStack {
                Spacer()
                if !friendsList.isEmpty {
                    EditButton()
                        .onTapGesture {
                            isEditing.toggle() // Toggle the edit mode
                        }
                        .padding(.trailing, 10)
                }
            }
            .padding()
            
            if friendsList.isEmpty {
                Text("No friends found")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(friendsList, id: \.id) { currFriend in
                        let friend = Friend(
                            name: currFriend.name,
                            email: currFriend.email
                        )
                        NavigationLink(
                            destination: UserProfileView(friend: friend)
                                .environmentObject(friendsController)
                                .environmentObject(favoriteController)
                        )
                        {
                            HStack {
                                Text("\(currFriend.name)")
                            }
                        }
                    }
                    .onDelete(perform: removeFriend) // Enable swipe-to-delete for single item removal
                }
            }
            
            if !friendsList.isEmpty {
                Button(action: removeAllFriends) {
                    Image(systemName: "trash")
                        .foregroundColor(.gray)
                    Text("Remove All")
                        .foregroundColor(.red)
                }
                .padding()
            }
        }
        .onAppear {
            if friendsList.isEmpty {
                friendsController.getAllFriends { retrievedFriendsList, error in
                    if let error = error {
                        // Handle the error
                        print("Error retrieving Friends:", error)
                    } else if let retrievedFriendsList = retrievedFriendsList {
                        // Update the friendsList with the received data
                        self.friendsList = retrievedFriendsList
                    }
                }
            }
        }

    }
    
    // Function to remove a single favorite item
    func removeFriend(at offsets: IndexSet) {
        // Get the event to delete using offsets
        let friendToDelete = friendsList[offsets.first!]
        
        // Call the deleteEvent function from the controller
        friendsController.deleteFriends(friendToDelete: friendToDelete)
        
        // Remove the item from the list
        friendsList.remove(atOffsets: offsets)
    }
    
    // Function to remove all favorite items
    func removeAllFriends() {
        for friend in friendsList {
            friendsController.deleteFriends(friendToDelete: friend)
        }
        
        friendsList.removeAll()
    }
}



struct MyFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        MyFriendsView()
    }
}

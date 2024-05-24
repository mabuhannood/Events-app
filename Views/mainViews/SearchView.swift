//
//  SearchView.swift
//  Group3
//
//  Created by Diya Patel on 2023-07-01.
//

import SwiftUI
struct SearchView: View {
    @State private var searchText = ""
    @State private var searchResults: [Friend] = []
    @State private var isSearching = false
    @State private var searchError: Error?
    
    @EnvironmentObject var userProfileController: UserProfileController
    @EnvironmentObject var friendsController: FriendsController
    @EnvironmentObject var favoritesController: FavoritesController


    var body: some View {
        VStack {
            TextField("Search for a user", text: $searchText, onCommit: searchFriends)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if isSearching {
                ProgressView()
                    .padding()
            } else {
                if let error = searchError {
                    Text("Error searching for friends: \(error.localizedDescription)")
                        .foregroundColor(.red)
                } else {
                    List(searchResults, id: \.id) { friend in
                        
                        NavigationLink(
                            destination: UserProfileView(friend: friend)
                                .environmentObject(friendsController)
                                .environmentObject(favoritesController)
                        ) {
                            HStack {
                                Text(friend.name)
                
                            }
                        }
                        
                    }
                    .listStyle(.plain)
                    .padding()
                }
            }
        }
    }

    private func searchFriends() {
        isSearching = true

        // Call the searchFriend function to search for friends
        userProfileController.searchUser(name: searchText.lowercased()) { friends, error in
            isSearching = false
            searchResults = friends ?? []
            searchError = error
        }
    }
}

//
//  ContentView.swift
//  Group3
//
//  Created by Diya Patel on 2023-06-28.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct ContentView: View {
    
    let authController = AuthController()
    let userProfileController = UserProfileController.getInstance() ?? UserProfileController(store: Firestore.firestore())
    let friendsController = FriendsController.getInstance() ?? FriendsController(store: Firestore.firestore())
    let favoritesController = FavoritesController.getInstance() ?? FavoritesController(store: Firestore.firestore())
    
    @State private var root : RootView = .Login
    
    var body: some View {
        
        NavigationView {
            switch root {
            case .Login:
                SigninView(rootScreen: $root).environmentObject(authController).environmentObject(userProfileController)
            case .Signup:
                SignUpView(rootScreen: $root).environmentObject(authController).environmentObject(userProfileController)
            case .Home:
                HomeView(rootScreen: $root).environmentObject(authController).environmentObject(userProfileController).environmentObject(friendsController).environmentObject(favoritesController)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

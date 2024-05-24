//
//  HomeView.swift
//  Group3
//
//  Created by Diya Patel on 2023-07-01.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authController: AuthController
    @EnvironmentObject var friendsController: FriendsController
    @EnvironmentObject var favoritesController: FavoritesController
    @EnvironmentObject var userProfileController : UserProfileController

    
    @Binding var rootScreen: RootView
    
    
    @State private var selectedTab = 0
    
    @State private var userProfileIndex: Int?
    
    var body: some View {
        VStack{
            TabView {
                ActivityListView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(0)
                
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Find Friends")
                    }
                    .tag(1)
                
                FavoriteView()
                    .tabItem {
                        Image(systemName: "chart.bar")
                        Text("My Events")
                    }
                    .tag(2)
                
                MyFriendsView()
                    .tabItem {
                        Image(systemName: "person.2")
                        Text("Friends")
                    }
                    .tag(3)
            }
                .navigationBarItems(leading: HStack {
                    Image(systemName: "wand.and.stars.inverse")
                        .foregroundColor(.indigo)

                    Text("Hello \(userProfileController.userProfile.name)!")
                        .font(.headline)
                    
                }).toolbar{
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                     
                        Button(action: {
                            rootScreen = .Login
                        }) {
                            Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.forward")
                                .foregroundColor(.pink)
                        }
                    }
                }

        } //
        
        .onAppear {
//                        self.dbHelper.getUserData()
        }
        
    }
}


//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

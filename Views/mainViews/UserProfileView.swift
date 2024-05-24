//
//  UserProfileView.swift
//  Group3
//
//  Created by Diya Patel on 2023-06-28.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var friendsControlelr: FriendsController
    @EnvironmentObject var favoritesController: FavoritesController

    @State var friend: Friend
    @State private var favList: [Event] = []

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack (alignment: .leading){
            HStack {
                Image(systemName: "person.fill")
                    .font(.system(size: 125))
                
                VStack (alignment: .leading){
                    Text(friend.name)
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    
                    
                    Text("I'm attending \(favList.count) events!")
                        .fontWeight(.regular)
                        .font(.system(size: 18))
                        .padding(.top,3)
                    
                    
                    Button(action: {
                        addFriend(friend: friend)
                    }) {
                        Text("Add Friend")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.indigo)
                            .cornerRadius(10)
                    }
                }
            }
            Divider()
            
     
                Text("\(friend.name)'s next event:")
                    .fontWeight(.regular)
                    .font(.system(size: 20))
                    .padding(.top,30)
                    .padding(.horizontal,20)

            List {
                ForEach(favList.sorted(by: { $0.date < $1.date }), id: \.id) { currEvent in
                    let event = Event(
                        title: currEvent.title,
                        lat: currEvent.lat,
                        long: currEvent.long,
                        address: currEvent.address,
                        description: currEvent.description,
                        price: Double(currEvent.price),
                        venueName: currEvent.venueName,
                        date: currEvent.date,
                        performers: currEvent.performers
                    )
                    
                    VStack(alignment: .leading) {
                        Text("\(currEvent.title)")
                        HStack {
                            Text(event.date.components(separatedBy: "T").first?.replacingOccurrences(of: "T", with: " at ") ?? "")
                            Text(" | ")
                            Text("\(currEvent.address)")
                        }
                    }
                }
            }.listStyle(.plain)

            
            
      
            
        }
                .onAppear {
            if favList.isEmpty {
                favoritesController.getAllFavorites { eventList, error in
                    if let error = error {
                        // Handle the error
                        print("Error retrieving favorites:", error)
                    } else if let eventList = eventList {
                        // Update the eventsList with the received data
                        favList = eventList
                    }
                }
            }
        }

    }
    
    func addFriend(friend: Friend) {
        friendsControlelr.addFriend(friend: friend)
    }
}




//struct UserProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserProfileView()
//    }
//}

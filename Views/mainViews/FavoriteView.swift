//
//  FavoriteView.swift
//  Group3
//
//  Created by Diya Patel on 2023-06-28.
//

import SwiftUI

struct FavoriteView: View {
    @State private var favList: [Event] = []
    @EnvironmentObject var favoritesController: FavoritesController
    @Environment(\.presentationMode) var presentationMode
    @State private var isEditing = false // Add state variable for edit mode
    
    var body: some View {
        VStack {
            // Add edit button and remove all button
            HStack {
                Spacer()
                if !favList.isEmpty {
                    EditButton()
                        .onTapGesture {
                            isEditing.toggle() // Toggle the edit mode
                        }
                        .padding(.trailing, 10)
                }
            }
            .padding()
            
            if favList.isEmpty {
                Text("You have no events at the moment")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(favList, id: \.id) { currEvent in
                        let event = Event(
                            title: currEvent.title,
                            lat: currEvent.lat,
                            long: currEvent.long,
                            address: currEvent.address,
                            description: currEvent.description,
                            price: Double(currEvent.price),
                            venueName:currEvent.venueName,
                            date:currEvent.date,
                            performers:currEvent.performers
                        )
                        NavigationLink(
                            destination: ActivityDetailView(event: event)
                                .environmentObject(favoritesController)
                        ) {
                            HStack {
                                Text("\(currEvent.title)")
                                Spacer()
                                Text(event.date.components(separatedBy: "T").first?.replacingOccurrences(of: "T", with: " at ") ?? "")
                            }
                        }
                    }
                    .onDelete(perform: removeFavorite) // Enable swipe-to-delete for single item removal
                }
            }
            
            if !favList.isEmpty {
                Button(action: removeAllFavorites) {
                    Image(systemName: "trash")
                        .foregroundColor(.gray)
                    Text("Remove All")
                        .foregroundColor(.red)
                }
                .padding()
            }
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
    
    // Function to remove a single favorite item
    func removeFavorite(at offsets: IndexSet) {
        // Get the event to delete using offsets
        let eventToDelete = favList[offsets.first!]
        
        // Call the deleteEvent function from the controller
        favoritesController.deleteEvent(eventToDelete: eventToDelete)
        
        // Remove the item from the list
        favList.remove(atOffsets: offsets)
    }
    
    // Function to remove all favorite items
    func removeAllFavorites() {
        for event in favList {
            favoritesController.deleteEvent(eventToDelete: event)
        }
        
        favList.removeAll()
    }
}


//struct FavoriteView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoriteView()
//    }
//}

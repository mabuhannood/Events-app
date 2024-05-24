//
//  ActivityDetailView.swift
//  Group3
//
//

import SwiftUI
import MapKit

struct ActivityDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var event: Event
    
    @State var lat: Double = 0.0
    @State var long: Double = 0.0
    
    @EnvironmentObject var favoritesController: FavoritesController
    
    let locationController = LocationController()
    
    @State private var isUpdateSuccessful = false
    @State private var isError = false
    @State private var errorMessage = ""
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d, yyyy"
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    var body: some View {
        VStack {
            Text("\(event.title)")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            Text("Venue: \(event.venueName)")
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)
         
            Text(event.date.replacingOccurrences(of: "T", with: " at "))
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)
            
//            Text(event.performers)
//                .multilineTextAlignment(.center)
//                .padding(.bottom, 16)

            
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.indigo)
                Text(event.address)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 8)
            
            
            if event.price != 0 {
                           Text(String(format: "$%.2f", event.price))
                               .font(.title3)
                               .fontWeight(.bold)
                               .foregroundColor(.pink)
                               .padding(.bottom, 16)
                       }
            
            MapView(locationHelper: locationController, lat: $lat, long: $long)
                .frame(height: 300)
                .cornerRadius(12)
                .padding(.bottom, 16)
            
            Button(action: {
                addToFavorites(event: event)
            }) {
                Text("Add to Favorites")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.indigo)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
        .onAppear() {
            self.lat = event.lat
            self.long = event.long
            
            print(self.lat, self.long)
        }
        .alert(isPresented: $isUpdateSuccessful) {
            Alert(
                title: Text("Success"),
                message: Text("Event added to favorites successfully."),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(isPresented: $isError) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func addToFavorites(event: Event) {
        favoritesController.addEvent(event: event) { error in
            if let error = error {
                errorMessage = "Failed to add event to favorites: \(error.localizedDescription)"
                isError = true
            } else {
                isUpdateSuccessful = true
            }
        }
    }
}



//struct ParkingDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ParkingDetailView()
//    }
//}

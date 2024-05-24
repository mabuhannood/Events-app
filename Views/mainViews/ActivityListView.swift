//
//  ActivityListView.swift
//  Group3
//
//  Created by Diya Patel on 2023-06-28.
//

import SwiftUI

struct ActivityListView: View {
    @EnvironmentObject var favoritesController: FavoritesController
    let locationController = LocationController()

    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode

    @State private var long: Double = 0.0
    @State private var lat: Double = 0.0
    @State private var cityName = ""
    @State var eventsList: [Events] = []
    @State var apiResponse: EventResponse = EventResponse(events: [])
    @State private var isShowingDeleteAlert = false

    var body: some View {
        VStack {
            
            Text("Check events nearby or search for an event")
                .padding(.top,30)
                .font(.subheadline)
            TextField("Search City", text: $cityName, onCommit: searchByCity)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            
            
            List(eventsList, id: \.id) { currEvent in
                let event = Event(
                    id: String(currEvent.id),
                    title: currEvent.title,
                    lat: currEvent.venue.location.lat,
                    long: currEvent.venue.location.lon,
                    address: currEvent.venue.address,
                    description: currEvent.description,
                    price: Double(currEvent.stats.average_price ?? 0),
                    venueName: currEvent.venue.name,
                    date:currEvent.datetime_local,
                    performers: currEvent.performers[0].name
                )
                NavigationLink(
                    destination: ActivityDetailView(event: event)
                        .environmentObject(favoritesController)
                ) {
                    HStack {
                        Text("\(currEvent.title)")
           

                    }
                }
            }
            Spacer()
        }
        .onAppear {
            updateLocation()
            loadDataFromAPI()
        }
        .onChange(of: locationController.currentLocation) { _ in
            updateLocation()
            loadDataFromAPI()
        }
    }

    func updateLocation() {
        if let currentLocation = locationController.currentLocation {
            self.lat = currentLocation.coordinate.latitude
            self.long = currentLocation.coordinate.longitude

        }
    }

    func searchByCity() {
        locationController.doForwardGeocoding(address: cityName) { result in
            switch result {
            case .success(let coordinates):
                self.lat = coordinates.0
                self.long = coordinates.1
                
                print("after search", coordinates)
                loadDataFromAPI()
            case .failure(let error):
                print("Forward geocoding error:", error.localizedDescription)
            }
        }
    }

    func loadDataFromAPI() {
        print("Getting data from API")

        let baseURL = "https://api.seatgeek.com/2/events"
        let latitude = String(format: "%.4f", lat)
        let longitude = String(format: "%.4f", long)
        let clientID = "MzQ1Njg3OTZ8MTY4NzkyODM0Ny4xNzYyNDI"

        let urlString = "\(baseURL)?lat=\(latitude)&lon=\(longitude)&client_id=\(clientID)"

        guard let apiURL = URL(string: urlString) else {
            print("ERROR: Cannot convert API address to a URL object")
            return
        }

        let request = URLRequest(url: apiURL)

        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response, error: Error?) in
            if let error = error {
                print("ERROR: Network error: \(error)")
                return
            }

            if let jsonData = data {
                print("Data retrieved")
                if let decodedResponse = try? JSONDecoder().decode(EventResponse.self, from: jsonData) {
                    DispatchQueue.main.async {
                        print(decodedResponse)
                        self.apiResponse = decodedResponse
                        self.eventsList = apiResponse.events
                    }
                } else {
                    print("ERROR: Error converting data to JSON")
                }
            } else {
                print("ERROR: Did not receive data from the API")
            }
        }
        task.resume()
    }
}


//struct ActivityListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityListView()
//    }
//}

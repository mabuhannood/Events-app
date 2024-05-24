//
//  MapView.swift
//  Group3
//
//  Created by Mohammad AbuHannood on 2023-07-08.
//

import SwiftUI
import MapKit

struct MapView: View {
    var locationHelper : LocationController
    @Binding var lat: Double
    @Binding var long: Double
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            if (self.long != nil){
                MyMap(lat: $lat, long: $long).environmentObject(locationHelper)
                    
            }else{
                Text("No Location available")
            }
        }
    }//body
}


struct MyMap: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    @EnvironmentObject var locationController: LocationController
    @Binding var lat: Double
    @Binding var long: Double
    
    func makeUIView(context: Context) -> MKMapView {
        let sourceCordinates: CLLocationCoordinate2D
        let region: MKCoordinateRegion
        
//        if let currentLocation = self.locationController.currentLocation {
//            sourceCordinates = currentLocation.coordinate
//        } else {
//            sourceCordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
//        }
        
        sourceCordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        region = MKCoordinateRegion(center: sourceCordinates, span: span)
        
        let map = MKMapView()
        
        map.mapType = MKMapType.hybrid
        map.setRegion(region, animated: true)
        map.showsUserLocation = true
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let sourceCordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region: MKCoordinateRegion
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        region = MKCoordinateRegion(center: sourceCordinates, span: span)
        
        uiView.setRegion(region, animated: true)
        self.locationController.addPinToMap(mapView: uiView, coordinates: sourceCordinates)
    }
}


//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}



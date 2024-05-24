//
//  Group3App.swift
//  Group3
//
//  Created by Diya Patel on 2023-06-28.
//

import SwiftUI
import Firebase

@main
struct Group3App: App {
    
    init(){
        //configure Firebase in the project
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

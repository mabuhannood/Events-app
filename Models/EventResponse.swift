//
//  Events.swift
//  Group3
//
//  Created by Mohammad AbuHannood on 2023-07-06.
//


import Foundation

struct Location: Codable {
    var lat:Double
    var lon:Double
}

struct Venue:Codable {
    var name:String
    var state: String
    var url: String
    var location:Location
    var address:String
    var city: String
    var country: String
}
struct Stats:Codable {
    var average_price: Int?
}

struct Performers:Codable {
    var name:String
}

struct Events:Codable {
    var id:Int
    var title:String
    var description:String
    var type: String
    var venue: Venue
    var stats: Stats
    var datetime_local:String
    var performers:[Performers]
}

struct EventResponse:Codable{
    var events: [Events]
}


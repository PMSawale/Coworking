//
//  fetchData.swift
//  Coworking
//
//  Created by Pankaj Sawale on 24/03/24.
//

import Foundation

struct getBooking: Codable {
    var bookings: [Bookings]
}



struct Bookings: Codable {
    var workspace_name: String
    var workspace_id: Int
    var booking_date: String
}


struct getSlots: Codable {
    var slots: [Slots]
}

struct Slots: Codable {
    var slot_name: String
    var slot_id: Int
    var slot_active: Bool
}


struct getAvailability: Codable {
    var availability: [Availabilit]
}

struct Availabilit: Codable {
    var workspace_name: String
    var workspace_id: Int
    var workspace_active: Bool
}

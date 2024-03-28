//
//  apiCollection.swift
//  Coworking
//
//  Created by Pankaj Sawale on 23/03/24.
//

import Foundation

struct API {
    static let BaseUrl = "https://demo0413095.mockable.io/digitalflake/api/"
    static var Register:String{
        return BaseUrl + "create_account"
    }
    static var LogIN:String{
        return BaseUrl + "login"
    }
    static var getBooking:String{
        return BaseUrl + "get_bookings?user_id="
    }
    static var getSlots:String{
        return BaseUrl + "get_slots?date="
    }
    static var availability:String{
        return BaseUrl + "get_availability?"
    }
    static var deskConfrim:String{
        return BaseUrl + "confirm_booking"
    }
}

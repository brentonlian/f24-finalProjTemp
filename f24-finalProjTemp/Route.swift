//
//  File.swift
//  f24-finalProjTemp
//
//  Created by Brenton on 11/27/24.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

// MARK: - Welcome
struct Welcome: Codable {
    let routes: [Route]
}

// MARK: - Route
struct Route: Codable {
    let compactDisplayShortName: DisplayShortName
    let globalRouteID: String
    let itineraries: [Itinerary]
    let modeName: String
    let realTimeRouteID: String
    let routeColor: String
    let routeDisplayShortName: DisplayShortName
    let routeImage, routeLongName: String
    let routeNetworkID: String
    let routeNetworkName: String
    let routeShortName: String
    let routeTextColor: String
    let routeType: Int
    let sortingKey, ttsLongName, ttsShortName: String
    //new property
    var isSelected: Bool = false
    //UUID to be identifiable
    //var id: UUID = UUID()

    enum CodingKeys: String, CodingKey {
        case compactDisplayShortName = "compact_display_short_name"
        case globalRouteID = "global_route_id"
        case itineraries
        case modeName = "mode_name"
        case realTimeRouteID = "real_time_route_id"
        case routeColor = "route_color"
        case routeDisplayShortName = "route_display_short_name"
        case routeImage = "route_image"
        case routeLongName = "route_long_name"
        case routeNetworkID = "route_network_id"
        case routeNetworkName = "route_network_name"
        case routeShortName = "route_short_name"
        case routeTextColor = "route_text_color"
        case routeType = "route_type"
        case sortingKey = "sorting_key"
        case ttsLongName = "tts_long_name"
        case ttsShortName = "tts_short_name"
    }
}

// MARK: - DisplayShortName
struct DisplayShortName: Codable {
    let boxedText: String
    let elements: [String?]
    let routeNameRedundancy: Bool

    enum CodingKeys: String, CodingKey {
        case boxedText = "boxed_text"
        case elements
        case routeNameRedundancy = "route_name_redundancy"
    }
}

// MARK: - Itinerary
struct Itinerary: Codable {
    let branchCode: String
    let closestStop: ClosestStop
    let directionHeadsign: String
    let directionID: Int
    let headsign, mergedHeadsign: String
    let scheduleItems: [ScheduleItem]

    enum CodingKeys: String, CodingKey {
        case branchCode = "branch_code"
        case closestStop = "closest_stop"
        case directionHeadsign = "direction_headsign"
        case directionID = "direction_id"
        case headsign
        case mergedHeadsign = "merged_headsign"
        case scheduleItems = "schedule_items"
    }
}

// MARK: - ClosestStop
struct ClosestStop: Codable {
    let globalStopID: String
    let locationType: Int
    //Changed from JSONNull? to String?
    let parentStationGlobalStopID: String?
    let routeType: Int
    let rtStopID, stopCode: String
    let stopLat, stopLon: Double
    let stopName: String
    let wheelchairBoarding: Int

    enum CodingKeys: String, CodingKey {
        case globalStopID = "global_stop_id"
        case locationType = "location_type"
        case parentStationGlobalStopID = "parent_station_global_stop_id"
        case routeType = "route_type"
        case rtStopID = "rt_stop_id"
        case stopCode = "stop_code"
        case stopLat = "stop_lat"
        case stopLon = "stop_lon"
        case stopName = "stop_name"
        case wheelchairBoarding = "wheelchair_boarding"
    }
}

// MARK: - ScheduleItem
struct ScheduleItem: Codable {
    let departureTime: Int
    let isCancelled, isRealTime: Bool
    let rtTripID: String
    let scheduledDepartureTime: Int
    let tripSearchKey: String
    let wheelchairAccessible: Int

    enum CodingKeys: String, CodingKey {
        case departureTime = "departure_time"
        case isCancelled = "is_cancelled"
        case isRealTime = "is_real_time"
        case rtTripID = "rt_trip_id"
        case scheduledDepartureTime = "scheduled_departure_time"
        case tripSearchKey = "trip_search_key"
        case wheelchairAccessible = "wheelchair_accessible"
    }
}

//Change to String
//enum ModeName: String, Codable {
    //case bus = "Bus"
//}

//Changed to string
//enum RouteColor: String, Codable {
    //case e87F0E = "e87f0e"
    //case the62A744 = "62a744"
//}

//enum RouteNetworkID: String, Codable {
    //case goTriangleRaleigh = "GoTriangle|Raleigh"
    //case piedmontAuthorityForRegionalTransportationPARTGreensboro = "Piedmont Authority for Regional Transportation (PART)|Greensboro"
//}

//enum RouteNetworkName: String, Codable {
    //case goTriangle = "GoTriangle"
    //case piedmontAuthorityForRegionalTransportationPART = "Piedmont Authority for Regional Transportation (PART)"
//}

//enum RouteTextColor: String, Codable {
    //case ffffff = "ffffff"
//}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}

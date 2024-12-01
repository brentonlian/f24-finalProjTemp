import Foundation

// MARK: - Welcome
struct stopWelcome: Codable {
    let stopItineraries: [stopItinerary]
    let stopRoute: stopRoute
}

// MARK: - Itinerary
struct stopItinerary: Codable {
    let stopBranchCode: String
    let stopCanonicalItinerary: Bool
    let stopDirectionHeadsign: DirectionHeadsign
    let stopDirectionID: Int
    let stopHeadsign: String
    let stopIsActive: Bool
    let stopMergedHeadsign: String
    let stopShape: String
    let stopStops: [stopStop]

    enum CodingKeys: String, CodingKey {
        case stopBranchCode = "branch_code"
        case stopCanonicalItinerary = "canonical_itinerary"
        case stopDirectionHeadsign = "direction_headsign"
        case stopDirectionID = "direction_id"
        case stopHeadsign = "headsign"
        case stopIsActive = "is_active"
        case stopMergedHeadsign = "merged_headsign"
        case stopShape = "shape"
        case stopStops = "stops"
    }
}

//Change to String instead
//enum DirectionHeadsign: String, Codable {
    //case stopManhattan = "Manhattan"
    //case stopQueens = "Queens"
//}

// MARK: - Stop
struct stopStop: Codable {
    let stopGlobalStopID: String
    let stopLocationType: Int
    let stopNextDeparture: stopNextDeparture
    let stopParentStationGlobalStopID: String
    let stopRouteType: Int
    let stopRtStopID: String
    let stopStopCode: String
    let stopStopLat: Double
    let stopStopLon: Double
    let stopStopName: String
    let stopWheelchairBoarding: Int

    enum CodingKeys: String, CodingKey {
        case stopGlobalStopID = "global_stop_id"
        case stopLocationType = "location_type"
        case stopNextDeparture = "next_departure"
        case stopParentStationGlobalStopID = "parent_station_global_stop_id"
        case stopRouteType = "route_type"
        case stopRtStopID = "rt_stop_id"
        case stopStopCode = "stop_code"
        case stopStopLat = "stop_lat"
        case stopStopLon = "stop_lon"
        case stopStopName = "stop_name"
        case stopWheelchairBoarding = "wheelchair_boarding"
    }
}

// MARK: - NextDeparture
struct stopNextDeparture: Codable {
    let stopDepartureTime: Int
    let stopIsCancelled: Bool
    let stopIsRealTime: Bool
    let stopRtTripID: String
    let stopScheduledDepartureTime: Int
    let stopTripSearchKey: String
    let stopWheelchairAccessible: Int

    enum CodingKeys: String, CodingKey {
        case stopDepartureTime = "departure_time"
        case stopIsCancelled = "is_cancelled"
        case stopIsRealTime = "is_real_time"
        case stopRtTripID = "rt_trip_id"
        case stopScheduledDepartureTime = "scheduled_departure_time"
        case stopTripSearchKey = "trip_search_key"
        case stopWheelchairAccessible = "wheelchair_accessible"
    }
}

// MARK: - Route
struct stopRoute: Codable {
    let stopCompactDisplayShortName: stopDisplayShortName
    let stopGlobalRouteID: String
    let stopModeName: String
    let stopRealTimeRouteID: String
    let stopRouteColor: String
    let stopRouteDisplayShortName: stopDisplayShortName
    let stopRouteImage: String
    let stopRouteLongName: String
    let stopRouteNetworkID: String
    let stopRouteNetworkName: String
    let stopRouteShortName: String
    let stopRouteTextColor: String
    let stopRouteType: Int
    let stopSortingKey: String
    let stopTtsLongName: String
    let stopTtsShortName: String

    enum CodingKeys: String, CodingKey {
        case stopCompactDisplayShortName = "compact_display_short_name"
        case stopGlobalRouteID = "global_route_id"
        case stopModeName = "mode_name"
        case stopRealTimeRouteID = "real_time_route_id"
        case stopRouteColor = "route_color"
        case stopRouteDisplayShortName = "route_display_short_name"
        case stopRouteImage = "route_image"
        case stopRouteLongName = "route_long_name"
        case stopRouteNetworkID = "route_network_id"
        case stopRouteNetworkName = "route_network_name"
        case stopRouteShortName = "route_short_name"
        case stopRouteTextColor = "route_text_color"
        case stopRouteType = "route_type"
        case stopSortingKey = "sorting_key"
        case stopTtsLongName = "tts_long_name"
        case stopTtsShortName = "tts_short_name"
    }
}

// MARK: - DisplayShortName
struct stopDisplayShortName: Codable {
    let stopBoxedText: String
    let stopElements: [String?]
    let stopRouteNameRedundancy: Bool

    enum CodingKeys: String, CodingKey {
        case stopBoxedText = "boxed_text"
        case stopElements = "elements"
        case stopRouteNameRedundancy = "route_name_redundancy"
    }
}

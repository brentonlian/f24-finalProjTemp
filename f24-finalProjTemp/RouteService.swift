//
//  ClassroomService.swift
//  f24-finalProjTemp
//
//  Created by Brenton on 11/27/24.
//


//
//  ClassroomService.swift
//  f24Deskovery
//
//  Created by Brenton on 11/5/24.
//

import Foundation

struct RouteService {
    public static func fetchRoutes(latitude: String, longitude: String, maxDistance: String) async throws -> [Route] {
        // apiKey env var
        guard let apiKey = ProcessInfo.processInfo.environment["apiKey"] else{
            fatalError("apiKey not set in the environment")
        }
        // Build the URL with query parameters
        //let urlString = "https://your-api-url.com/routes?lat=\(latitude)&lon=\(longitude)&distance=\(maxDistance)"
        let urlString = "https://external.transitapp.com/v3/public/nearby_routes?lat=\(latitude)&lon=\(longitude)&max_distance=\(maxDistance)"
        guard let url = URL(string: urlString) else { fatalError("Invalid URL") }
        print("Request URL: \(url)")

        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Perform the network call
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            // Log raw response data
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if let headers = httpResponse.allHeaderFields as? [String: String] {
                    print("Response Headers: \(headers)")
                }
            }

            print("Raw Data: \(String(data: data, encoding: .utf8) ?? "Invalid Data")")

            // Decode the JSON response
            let welcomeResponse = try JSONDecoder().decode(Welcome.self, from: data)
            print("Decoded Response: \(welcomeResponse)")

            // Return the array of routes
            return welcomeResponse.routes

        } catch {
            // Log the error
            print("Error occurred: \(error)")
            throw error
        }
    }
}





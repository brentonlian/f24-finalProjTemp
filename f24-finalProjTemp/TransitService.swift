//
//  TransitService.swift
//  f24-finalProjTemp
//
//  Created by Brenton on 11/18/24.
//

import Foundation

struct TransitAPIResponse: Codable {
    let routes: [Route] // Replace with the actual structure of your API's JSON response

    struct Route: Codable {
        let name: String
        let distance: Double
    }
}

class TransitService {
    static let shared = TransitService() // Singleton instance for reuse

    private init() {}

    func fetchNearbyRoutes(latitude: Double, longitude: Double, maxDistance: Int, completion: @escaping (Result<[TransitAPIResponse.Route], Error>) -> Void) {
        // Construct the URL
        guard var urlComponents = URLComponents(string: "https://external.transitapp.com/v3/public/nearby_routes") else {
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "latitude", value: "\(latitude)"),
            URLQueryItem(name: "longitude", value: "\(longitude)"),
            URLQueryItem(name: "max_distance", value: "\(maxDistance)")
        ]

        guard let url = urlComponents.url else {
            print("Invalid URL")
            return
        }

        // Create a URL request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("2a50d0dfcd05521cb56cc60f1db48ed27071ea6597212d3bc0fcb889acecae6a", forHTTPHeaderField: "Authorization") // Replace with your API key

        // Perform the network call
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
                }
                return
            }

            do {
                // Decode the JSON response
                let decodedResponse = try JSONDecoder().decode(TransitAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse.routes))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

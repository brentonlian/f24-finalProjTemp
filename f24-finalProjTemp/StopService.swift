import Foundation

struct StopService {
    public static func fetchStops(globalRouteID: String) async throws -> [stopStop] {
        // Ensure the API key is available
        guard let apiKey = ProcessInfo.processInfo.environment["apiKey"] else {
            fatalError("apiKey not set in the environment")
        }

        // Build the URL with query parameters
        let urlString = "https://external.transitapp.com/v3/public/route_details?global_route_id=\(globalRouteID)&include_next_departure=true"
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        print("Request URL: \(url)")

        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "apiKey") // Use "apiKey" as the header field name
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
            let stopsResponse = try JSONDecoder().decode(stopWelcome.self, from: data)
            print("Decoded Response: \(stopsResponse)")

            // Extract and return the stops from the itineraries
            let stops = stopsResponse.stopItineraries.flatMap { $0.stopStops }
            print("Extracted Stops: \(stops)")
            return stops

        } catch {
            // Log the error
            print("Error occurred: \(error)")
            throw error
        }
    }
}

import SwiftUI

struct NearbyRoutesView: View {
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var maxDistance: String = ""
    @State private var routes: [Route] = []
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Nearby Routes Finder")
                .font(.headline)
                .padding()

            // Latitude Text Field
            TextField("Enter Latitude", text: $latitude)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .keyboardType(.decimalPad)

            // Longitude Text Field
            TextField("Enter Longitude", text: $longitude)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .keyboardType(.decimalPad)

            // Max Distance Text Field
            TextField("Enter Max Distance", text: $maxDistance)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .keyboardType(.numberPad)

            // Submit Button
            Button(action: {
                Task {
                    await fetchNearbyRoutes()
                }
            }) {
                Text("Find Routes")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top)

            // Display Error Message if Exists
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            }

            // Display Routes
            if !routes.isEmpty {
                List(routes, id: \.globalRouteID) { route in
                    VStack(alignment: .leading) {
                        Text(route.routeLongName)
                            .font(.headline)
                        Text("Short Name: \(route.routeShortName)")
                            .font(.subheadline)
                    }
                }
            }

            Spacer()
        }
        .padding()
    }

    // MARK: - Fetch Routes
    func fetchNearbyRoutes() async {
        do {
            // Validate input before making the request
            guard !latitude.isEmpty, !longitude.isEmpty, !maxDistance.isEmpty else {
                self.errorMessage = "All fields must be filled in."
                return
            }

            // Call the API
            let fetchedRoutes = try await RouteService.fetchRoutes(
                latitude: latitude,
                longitude: longitude,
                maxDistance: maxDistance
            )
            
            // Update the state
            DispatchQueue.main.async {
                self.routes = fetchedRoutes
                self.errorMessage = nil
            }
        } catch {
            // Handle and display the error
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.routes = []
            }
        }
    }
}

#Preview {
    NearbyRoutesView()
}

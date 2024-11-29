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

            TextField("Enter Latitude", text: $latitude)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .keyboardType(.decimalPad)

            TextField("Enter Longitude", text: $longitude)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .keyboardType(.decimalPad)

            TextField("Enter Max Distance", text: $maxDistance)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .keyboardType(.numberPad)

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

            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            }

            if !routes.isEmpty {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach($routes) { $route in
                            RouteView(route: route, isSelected: $route.isSelected)
                        }
                    }
                }
                .frame(maxHeight: 300)
                .scrollIndicators(.visible)
            }

            Spacer()
        }
        .padding()
    }

    func fetchNearbyRoutes() async {
        do {
            guard !latitude.isEmpty, !longitude.isEmpty, !maxDistance.isEmpty else {
                self.errorMessage = "All fields must be filled in."
                return
            }

            let fetchedRoutes = try await RouteService.fetchRoutes(
                latitude: latitude,
                longitude: longitude,
                maxDistance: maxDistance
            )
            DispatchQueue.main.async {
                self.routes = fetchedRoutes
                self.errorMessage = nil
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.routes = []
            }
        }
    }
}


struct RouteView: View {
    let route: Route
    @Binding var isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(route.routeLongName)
                .font(.headline)
                .foregroundColor(.primary)
            Text("Short Name: \(route.routeShortName)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Toggle selection
            Button(action: {
                isSelected.toggle()
            }) {
                Text(isSelected ? "Deselect" : "Select")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isSelected ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}


#Preview {
    NearbyRoutesView()
}

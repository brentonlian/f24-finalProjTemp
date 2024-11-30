import SwiftUI

struct NearbyRoutesView: View {
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var maxDistance: String = ""
    @State private var routes: [Route] = []
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
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
                            ForEach(routes, id: \.routeID) { route in
                                NavigationLink(destination: RouteDetailView(route: route)) {
                                    RouteRowView(route: route)
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 300)
                }

                Spacer()
            }
            .padding()
        }
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

struct RouteRowView: View {
    let route: Route

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(route.routeLongName)
                .font(.headline)
                .foregroundColor(.primary)
            Text("Short Name: \(route.routeShortName)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct RouteDetailView: View {
    let route: Route

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(route.routeLongName)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Route Short Name: \(route.routeShortName)")
                .font(.title2)

            if let description = route.description {
                Text("Description: \(description)")
                    .font(.body)
                    .foregroundColor(.secondary)
            }

            Text("Additional Route Details")
                .font(.headline)
                .padding(.top)

            VStack(alignment: .leading, spacing: 10) {
                Text("Route ID: \(route.routeID)")
                Text("Color: \(route.color)")
                Text("Text Color: \(route.textColor)")
                Text("Agency ID: \(route.agencyID)")
            }
            .font(.body)

            Spacer()
        }
        .padding()
        .navigationTitle("Route Details")
    }
}

#Preview {
    NearbyRoutesView()
}

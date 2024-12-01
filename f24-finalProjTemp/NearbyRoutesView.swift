import SwiftUI

struct NearbyRoutesView: View {
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var maxDistance: String = ""
    @State private var routes: [Route] = []
    @State private var selectedRouteID: String?
    @State private var stops: [ClosestStop] = []
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
                            ForEach(routes, id: \.id) { route in
                                RouteRowView(
                                    route: route,
                                    onSelect: {
                                        selectedRouteID = route.id
                                        Task {
                                            await fetchStops(for: route.id)
                                        }
                                    },
                                    isSelected: Binding(
                                        get: { selectedRouteID == route.id },
                                        set: { isSelected in
                                            selectedRouteID = isSelected ? route.id : nil
                                        }
                                    )
                                )
                            }
                        }
                    }
                    .frame(maxHeight: 300)
                }

                if !stops.isEmpty {
                    Text("Stops for Route \(selectedRouteID ?? "")")
                        .font(.headline)
                        .padding(.top)

                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 10) {
                            ForEach(stops, id: \.globalStopID) { stop in
                                StopRowView(stop: stop)
                            }
                        }
                    }
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

    func fetchStops(for routeID: String) async {
        do {
            let fetchedStops = try await StopService.fetchStops(globalRouteID: routeID)
            DispatchQueue.main.async {
                self.stops = fetchedStops
                self.errorMessage = nil
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.stops = []
            }
        }
    }
}

struct RouteRowView: View {
    let route: Route
    let onSelect: () -> Void
    @Binding var isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(route.routeLongName)
                .font(.headline)
                .foregroundColor(isSelected ? .blue : .primary)
            Text("Short Name: \(route.routeShortName)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(isSelected ? Color.blue.opacity(0.2) : Color(.systemGray6))
        .cornerRadius(10)
        .onTapGesture {
            isSelected.toggle()
            onSelect()
        }
    }
}

struct StopRowView: View {
    let stop: ClosestStop

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(stop.stopName)
                .font(.headline)
            Text("Latitude: \(stop.stopLat)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Longitude: \(stop.stopLon)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            if stop.wheelchairBoarding == 1 {
                Text("Wheelchair Accessible")
                    .font(.caption)
                    .foregroundColor(.green)
            } else {
                Text("No Wheelchair Access")
                    .font(.caption)
                    .foregroundColor(.red)
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

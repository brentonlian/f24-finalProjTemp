import SwiftUI
import MapKit

struct NearbyRoutesView: View {
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var maxDistance: String = ""
    @State private var routes: [Route] = []
    @State private var selectedRouteID: String?
    @State private var stops: [stopStop] = []
    @State private var errorMessage: String?
    @State private var isLoadingRoutes = false
    @State private var isLoadingStops = false

    var body: some View {
        NavigationStack {
            if !stops.isEmpty {
                // Full-screen stops view
                StopsListView(stops: stops)
                    .navigationTitle(selectedRouteName)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Back") {
                                stops = [] // Clear stops to return to the main view
                                //unselect route
                                selectedRouteID = nil
                                
                                
                            }
                            
                        }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Text(selectedRouteNameShort)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                    }
            } else {
                // Main view
                VStack(spacing: 20) {
                    // Inputs Section
                    InputSection(
                        latitude: $latitude,
                        longitude: $longitude,
                        maxDistance: $maxDistance
                    )

                    // Fetch Routes Button
                    Button(action: {
                        isLoadingRoutes = true
                        Task {
                            await fetchNearbyRoutes()
                            isLoadingRoutes = false
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

                    // Error Message
                    if let errorMessage = errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding(.top)
                    }

                    // Routes Section
                    if isLoadingRoutes {
                        ProgressView("Loading Routes...")
                            .padding()
                    } else if !routes.isEmpty {
                        RoutesListView(
                            routes: routes,
                            selectedRouteID: $selectedRouteID,
                            onSelectRoute: { routeID in
                                selectedRouteID = routeID
                                isLoadingStops = true
                                Task {
                                    await fetchStops(for: routeID)
                                    isLoadingStops = false
                                }
                            }
                        )
                    } else {
                        Text("No routes found.")
                            .foregroundColor(.gray)
                            .padding()
                    }

                    Spacer()
                    
                }
                .padding()
                .navigationTitle("Nearby Routes")

                // Footer
                Text("Powered by Transit API")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom)
                
            }
        }
    }
    
    //Find selected route name
    private var selectedRouteName: String {
            if let routeID = selectedRouteID,
               let route = routes.first(where: { $0.id == routeID }) {
                return route.routeLongName
            }
            return "Nearby Routes" // Default title
        }
    
    //Find selected route shortname
    private var selectedRouteNameShort: String {
            if let routeID = selectedRouteID,
               let route = routes.first(where: { $0.id == routeID }) {
                return route.routeShortName
            }
            return "Nearby Routes" // Default title
        }

    // Fetch Functions
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

// MARK: - Input Section
struct InputSection: View {
    @Binding var latitude: String
    @Binding var longitude: String
    @Binding var maxDistance: String

    var body: some View {
        VStack(spacing: 15) {
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

            TextField("Enter Max Distance: 0-1500 Meters", text: $maxDistance)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .keyboardType(.numberPad)
        }
    }
}

// MARK: - Routes List View
struct RoutesListView: View {
    let routes: [Route]
    @Binding var selectedRouteID: String?
    let onSelectRoute: (String) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 10) {
                ForEach(routes, id: \.id) { route in
                    RouteRowView(
                        route: route,
                        isSelected: Binding(
                            get: { selectedRouteID == route.id },
                            set: { isSelected in
                                if isSelected {
                                    selectedRouteID = route.id
                                    onSelectRoute(route.id)
                                }
                            }
                        )
                    )
                }
            }
        }
        .frame(maxHeight: 300)
    }
}



// MARK: - Route Row View
struct RouteRowView: View {
    let route: Route
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
        }
    }
}


//Plot coordinates on map
struct StopsListView: View {
    let stops: [stopStop]
    @State private var region: MKCoordinateRegion

    init(stops: [stopStop]) {
        self.stops = stops
        // Initialize the map region around the first stop, or provide a default region
        if let firstStop = stops.first {
            self._region = State(initialValue: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: firstStop.stopStopLat, longitude: firstStop.stopStopLon),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            ))
        } else {
            self._region = State(initialValue: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            ))
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Stops Map")
                .font(.headline)
                .padding(.top)

            // Map View
            Map(coordinateRegion: $region, annotationItems: stops) { stop in
                MapAnnotation(
                    coordinate: CLLocationCoordinate2D(latitude: stop.stopStopLat, longitude: stop.stopStopLon)
                ) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                        Text(stop.stopStopName)
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                }
            }
            .frame(height: 300)
            .cornerRadius(10)
            .padding(.bottom)

            // List of Stops
            Text("Stops List")
                .font(.headline)
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(stops, id: \.stopGlobalStopID) { stop in
                        StopRowView(stop: stop)
                    }
                }
            }
        }
        .padding()
    }
}


// MARK: - Stop Row View
struct StopRowView: View {
    let stop: stopStop

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(stop.stopStopName)
                .font(.headline)
            Text("Latitude: \(stop.stopStopLat)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Longitude: \(stop.stopStopLon)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            if stop.stopWheelchairBoarding == 1 {
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



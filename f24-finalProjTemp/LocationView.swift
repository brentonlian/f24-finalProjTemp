//
//  ContentView.swift
//  f24-finalProjTemp
//
//  Created by Brenton on 12/2/24.
//


import SwiftUI
import CoreLocation


struct LocationView: View {
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            if let coordinate = locationManager.lastKnownLocation {
                Text("Latitude: \(coordinate.latitude)")
                
                Text("Longitude: \(coordinate.longitude)")
            } else {
                Text("Unknown Location")
            }
            
            
            Button("Get location") {
                locationManager.checkLocationAuthorization()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview{
    LocationView()
}

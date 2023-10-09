//
//  LocationView.swift
//  MapPorto
//
//  Created by w.santos on 04/10/23.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D
{
    static let parking = CLLocationCoordinate2D(
        latitude: 41.15,
        longitude: -8.61024
    )
}

extension MKCoordinateRegion
{
    static let maia = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 41.2329,
            longitude: -8.62156),
        span: MKCoordinateSpan(
            latitudeDelta: 0.5,
            longitudeDelta: 0.5
        )
    )
    
    static let nazare = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 39.601875,
            longitude: -9.071212),
        span: MKCoordinateSpan(
            latitudeDelta: 0.5,
            longitudeDelta: 0.5
        )
    )
}


struct LocationView: View
{
    @EnvironmentObject private var vm: LocationViewModel
    var body: some View {
        ZStack {
            MapLayer(vm: vm)
        }
        .sheet(item: $vm.sheetLocation, onDismiss: nil) { location in
            LocationDetailView(locaiton: location)
        }
    }
}

#Preview {
    LocationView()
        .environmentObject(LocationViewModel())
}

extension LocationView
{
    private var header: some View
    {
        VStack {
            Button(action: vm.toggleLocationList) {
                Text(vm.mapLocation.name + " " + vm.mapLocation.cityName)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundStyle(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .animation(.none, value: vm.mapLocation)
                    .overlay(alignment: .leading) {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .padding()
                            .rotationEffect(Angle(
                                degrees:vm.showLocationList ? 180 :0)
                            )
                    }
            }
            
            if vm.showLocationList {
                LocationListView()
                    .foregroundStyle(.primary)
            }
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(
            color: Color.black.opacity(0.3),
            radius: 20,
            x: 0,
            y: 15
        )
    }
}

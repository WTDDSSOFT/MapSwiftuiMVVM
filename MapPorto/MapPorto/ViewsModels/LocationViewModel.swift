//
//  LocationsViewModel.swift
//  MapPorto
//
//  Created by w.santos on 04/10/23.
//

import Foundation
import MapKit
import SwiftUI

class LocationViewModel: ObservableObject
{
    //ALL load locations
    @Published var locations: [Location]
    
    //Current location on app
    @Published var mapLocation: Location {
        didSet {
            updateMapRegion(location: mapLocation)
        }
    }
    
    // Current region on  map
    @Published var mapRegion: MapCameraPosition = .region(.init())
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    // Show list of locations
    @Published var showLocationList: Bool = false
    
    // Show location detail sheet
    @Published var sheetLocation: Location? = nil
    
    init()
    {
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        
        self.updateMapRegion(location: locations.first!)
    }
    
    private func updateMapRegion(location: Location)
    {
        withAnimation(.easeInOut) {
            mapRegion = MapCameraPosition.region(   
                MKCoordinateRegion(
                center: location.coordinates,
                span: mapSpan
            ))
        }
    }
    
    func toggleLocationList()
    {
        withAnimation(.easeInOut) {
            showLocationList.toggle()
        }
    }
    
    func showNextLocation(location: Location)
    {
        withAnimation(.easeInOut) {
            mapLocation = location
            showLocationList = false
        }
    }
    
    func nextButtonPressed()
    {
        // Get current index
        guard
            let currentIndex = locations.firstIndex(where: {$0 == mapLocation}) else {
            print("Could not find current index in locations array! should never happen.")
            return
        }
        
        // Check if the nextIndex is valid
        let nextIndex = currentIndex + 1
        
        guard
            locations.indices.contains(nextIndex) else {
            // Next index NOT valid
            // Restart from 0
            guard let firstLocaiton = locations.first else  { return }
            showNextLocation(location: firstLocaiton)
            
            return
        }
        
        // next Index IS valid
        let nextLocation = locations[nextIndex]
        showNextLocation(location: nextLocation)
    }
    
}

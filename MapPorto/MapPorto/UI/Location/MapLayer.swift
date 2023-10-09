//
//  MapLayer.swift
//  MapPorto
//
//  Created by w.santos on 09/10/23.
//

import SwiftUI
import MapKit

struct MapLayer: View
{
    // ViewModel
    @StateObject var vm: LocationViewModel
    
    // view Properties
    @State private var position: MapCameraPosition = .automatic
    @State private var searchResults: [MKMapItem] = []
    @State private var visibleRegin: MKCoordinateRegion?
    @State private var selectedResult: MKMapItem?
    @State private var route: MKRoute?
    @State private var searchText = ""
    
    // set ipad max witdh
    let maxWidthForIpad: CGFloat = 700
    
    var body: some View {
        Map(position: $vm.mapRegion, selection: $selectedResult) {
            ForEach(vm.locations, id: \.id) { location in
                Annotation(location.cityName, coordinate: location.coordinates) {
                    LocationMapAnnotationView()
                        .scaleEffect(vm.mapLocation == location ? 1 : 0.7)
                        .shadow(radius: 10)
                        .onTapGesture {
                            vm.showNextLocation(location: location)
                        }
                }
                .annotationTitles(.hidden)
            }
            
            ForEach(searchResults, id: \.self) { result in
                Marker(item: result)
            }
            .annotationTitles(.hidden)
            
            UserAnnotation()
            
            if let route {
                MapPolyline(route)
                    .stroke(.blue, lineWidth: 5)
            }
        }
        .mapSheet(initialHeight: 100, sheetCornerRadius: 15) {
            NavigationStack {
                ScrollView {
                    VStack {
                        TextField("Search for location...", text: $searchText)
                            .textInputAutocapitalization(.never)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.subheadline)
                            .padding()
                            .presentationDetents([.fraction(0.99)])
                        HStack {
                            Spacer()
                            VStack(spacing: 0) {
                                if let selectedResult {
                                    ItemInfoView(selectedResult: selectedResult, route: route)
                                        .frame(height: 128)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding([.top, .horizontal])
                                }
                                BeanTwonButotn(
                                    position: $position,
                                    searchResults: $searchResults,
                                    visibleRegin: visibleRegin
                                ).padding(.all)
                            }
                            Spacer()
                        }
                    }         
                    .background(.thinMaterial)
                }
                .scrollIndicators(.hidden)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text(vm.mapLocation.cityName)
                            .font(.title3.bold())
                    }
                }          
                .background(.thinMaterial)

            }
        }
        .mapStyle(.standard(elevation: .realistic))
        //        .safeAreaInset(edge: .bottom) {
        
        //        }
        .onChange(of: searchResults) {
            position = .automatic
        }
        .onChange(of: selectedResult)
        {
            getDirections()
        }
        .onMapCameraChange { context in
            visibleRegin = context.region
        }
        .mapControls {
            MapCompass()
            MapScaleView()
            MapUserLocationButton()
        }
    }
}

#Preview {
    MapLayer(vm: LocationViewModel())
        .environmentObject(LocationViewModel())
}

extension MapLayer
{
    // Get the direction
    func getDirections()
    {
        route = nil
        guard let selectedResult else { return }
        
        let request = MKDirections.Request()
        request.source  = MKMapItem(
            placemark: MKPlacemark(coordinate: .parking)
        )
        request.destination = selectedResult
        
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first
        }
    }
    
    private var locationPreviewStack: some View
    {
        ZStack {
            ForEach(vm.locations) { location in
                if vm.mapLocation == location {
                    LocationPreviewView(location: location)
                        .shadow(color:.black.opacity(0.3),
                                radius: 10)
                        .padding()
                        .frame(maxWidth: maxWidthForIpad)
                        .frame(maxWidth: .infinity)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading))
                        )
                }
            }
        }
    }
    
    private func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        let response = try? await MKLocalSearch(request: request).start()
        self.searchResults =  response?.mapItems ?? []
    }
}

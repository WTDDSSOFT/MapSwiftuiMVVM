//
//  LocationDetailView.swift
//  MapPorto
//
//  Created by w.santos on 04/10/23.
//

import SwiftUI
import MapKit

struct LocationDetailView: View
{
    @EnvironmentObject private var vm: LocationViewModel
    
    let locaiton: Location
    
    var body: some View
    {
        ScrollView {
            VStack {
                imageSection
                    .shadow(color: .black.opacity(0.3), radius: 20, x:0, y: 10)
                
                VStack(alignment: .leading, spacing: 16) {
                    titleSection
                    Divider()
                    descriptionSection
                    Divider()
                    mapLayer
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .overlay(alignment: .topLeading) {
            backButton
        }
    }
    
}

#Preview {
    LocationDetailView(locaiton: LocationsDataService.locations.first!)
        .environmentObject(LocationViewModel())
}

extension  LocationDetailView
{
    private var imageSection: some View
    {
        TabView {
            ForEach(locaiton.imageNames, id: \.self) {
                Image($0)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: UIDevice.current.userInterfaceIdiom == .pad ? nil : UIScreen.main.bounds.width
                    )
                    .clipped()
            }
        }
        .frame(height: 500)
        .tabViewStyle(PageTabViewStyle())
        
    }
    
    private var titleSection: some View
    {
        VStack(alignment: .leading, spacing: 8) {
            Text(locaiton.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Text(locaiton.cityName)
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }
    
    private var descriptionSection: some View
    {
        VStack(alignment: .leading, spacing: 16) {
            Text(locaiton.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            if let url = URL(string: locaiton.link) {
                Link("Read more in Wikipedia", destination: url)
                    .font(.headline)
                    .tint(.blue)
            }
        }
    }
    
    private var mapLayer: some View
    {
        Map(coordinateRegion: .constant(MKCoordinateRegion(
            center: locaiton.coordinates,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))),
            annotationItems: [locaiton]) { location in
            MapAnnotation(coordinate: location.coordinates) {
                LocationMapAnnotationView()
                    .shadow(radius: 10)
            }
        }
        .allowsHitTesting(false)
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(30)
    }
    
    private var backButton: some View
    {
        Button {
            vm.sheetLocation = nil
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
                .padding(16)
                .foregroundStyle(.primary)
                .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(radius: 4)
                .padding()
        }

    }
}

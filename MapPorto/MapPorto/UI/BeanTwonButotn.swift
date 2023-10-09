//
//  BeanTwonButotn.swift
//  MapPorto
//
//  Created by w.santos on 08/10/23.
//

import SwiftUI
import MapKit


struct BeanTwonButotn: View
{
    @Binding var position: MapCameraPosition
    @Binding var searchResults: [MKMapItem]
    
    var visibleRegin: MKCoordinateRegion?
    
    var body: some View {
        buttonStack
            .labelStyle(.iconOnly)
    }
}

#Preview {
    BeanTwonButotn(
        position: .constant(.automatic),
        searchResults: .constant(.init())
    )
    .previewLayout(.sizeThatFits)
}


extension BeanTwonButotn
{
    func search(for query: String)
    {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = visibleRegin ?? MKCoordinateRegion(
            center: .parking ,
            span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125)
        )
        
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
        }
    }
    
    private var buttonStack: some View
    {
        HStack {
            Button {
                search(for: "playground")
            } label: {
                Label("Playgrounds",
                      systemImage: "figure.and.child.holdinghands")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                search(for: "beach")
            } label: {
                Label("Beaches",
                      systemImage: "beach.umbrella")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                position = .region(.maia)
            } label: {
                Label("Maia",
                      systemImage: "building.2")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                position = .region(.nazare)
            } label: {
                Label("Nazáre",
                      systemImage: "water.waves")
            }
            .buttonStyle(.borderedProminent)
        }
        
    }
}

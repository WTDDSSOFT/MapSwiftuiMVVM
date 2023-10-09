//
//  ItemInfoView.swift
//  MapPorto
//
//  Created by w.santos on 08/10/23.
//

import SwiftUI
import MapKit

struct ItemInfoView: View
{
    
    @State private var lookAroundScene: MKLookAroundScene?
    @State var selectedResult: MKMapItem
    @State var route: MKRoute?
    
    func getLookAroundScene()
    {
        lookAroundScene = nil
        Task {
            let request = MKLookAroundSceneRequest(mapItem: selectedResult)
            lookAroundScene = try? await request.scene
        }
    }
    
    private var travelTime: String?
    {
        guard let route else { return nil}
        let formatted = DateComponentsFormatter()
        formatted.unitsStyle = .abbreviated
        formatted.allowedUnits = [.hour, .minute]
        return formatted.string(from: route.expectedTravelTime)
        
    }
    
    var body: some View {
        LookAroundPreview(initialScene: lookAroundScene)
            .overlay(alignment: .bottomTrailing) {
                HStack {
                    Text("\(selectedResult.name ?? "")")
                    if let travelTime {
                        Text(travelTime)
                    }
                }
                .font(.caption)
                .foregroundStyle(.white)
                .padding(10)
            }
            .onAppear {
                getLookAroundScene()
            }
            .onChange(of: selectedResult) {
                getLookAroundScene()
            }
    }
}

#Preview {
    ItemInfoView(selectedResult: .init())
}

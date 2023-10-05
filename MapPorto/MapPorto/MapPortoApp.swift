//
//  MapPortoApp.swift
//  MapPorto
//
//  Created by w.santos on 04/10/23.
//

import SwiftUI

@main
struct MapPortoApp: App {
    
    @StateObject private var vm = LocationViewModel()

    var body: some Scene {
        WindowGroup {
            LocationView()
                .environmentObject(vm)
        }
    }
}

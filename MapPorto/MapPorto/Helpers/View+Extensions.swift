//
//  View+Extensions.swift
//  MapPorto
//
//  Created by w.santos on 09/10/23.
//

import Foundation
import SwiftUI
import MapKit

/// Custome View Modifier
///
extension Map
{
    @ViewBuilder
    func mapSheet<SheetContent: View>(initialHeight: CGFloat = 100,
                                sheetCornerRadius: CGFloat = 15,
                                @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        self
            .modifier(BottomSheetModifier(
                initialHeight: initialHeight,
                sheetCornerRadius: sheetCornerRadius,
                sheetView: content()
        ))
    }
}

/// helper view builder

fileprivate struct BottomSheetModifier<SheetContent: View>: ViewModifier
{
    var initialHeight: CGFloat
    var sheetCornerRadius: CGFloat
    var sheetView: SheetContent
    
    ///View properties
    @State private var showSheet: Bool = true
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $showSheet, content: {
                sheetView
                    .presentationDetents([.height(initialHeight), .medium, .fraction(0.99)])
                    .presentationCornerRadius(sheetCornerRadius)
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                    .interactiveDismissDisabled()
            }
        )
    }
    
}

//
//  RouteButtonView.swift
//  Musica
//
//  Created by Jared Kozar on 11/23/24.
//

import SwiftUI
import AVKit

struct RouteButtonView: UIViewRepresentable {
    func makeUIView(context: Context) -> AVRoutePickerView {
        let routePickerView = AVRoutePickerView()
        return routePickerView
    }
    
    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {
        // No update needed
    }
}

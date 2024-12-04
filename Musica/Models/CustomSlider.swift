//
//  Slider.swift
//  Musica
//
//  Created by Jared Kozar on 11/23/24.
//

import SwiftUI

struct CustomSlider: View {
    @Environment(SettingsManager.self) var settingsManager
    @Binding var sliderValue: Double
    @Binding var sliderActive: Bool
    @GestureState private var isActive: Bool = false
    var handler: (Double) -> Void
    
    var body: some View {
        GeometryReader { bounds in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(settingsManager.tintColor.color.tertiary)
                Capsule()
                    .fill(settingsManager.tintColor.color)
                    .frame(width: sliderValue * 360)
            }
            .frame(maxWidth: 360, maxHeight: isActive ? 15 : 10)
            .gesture(DragGesture(minimumDistance: 0.5, coordinateSpace: .local)
                .updating($isActive) { value, state, transaction in
                     state = true
                    sliderActive = true
                 }
                .onChanged({ value in
                    let percentProgress = value.location.x / bounds.size.width
                    sliderValue = min(1, max(0, percentProgress))
                })
                .onEnded({ (value) in
                    let percentProgress = value.location.x / bounds.size.width
                    sliderValue = min(1, max(0, percentProgress))
                    })
                 )
            .onChange(of: isActive) { oldState, newState in
                handler(sliderValue)
            }
        }
    }
}

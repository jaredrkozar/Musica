//
//  DiscView.swift
//  Musica
//
//  Created by Jared Kozar on 12/3/24.
//

import SwiftUI

struct DiscView: View {
    @Binding var sliderValue: Double
    @Binding var sliderActive: Bool
    @GestureState private var isActive: Bool = false
    var handler: (Double) -> Void
    @Environment(AudioManager.self) var audioManager
    @Environment(SettingsManager.self) var settingsManager
    
    private func location2Degrees(location: CGPoint, midX: CGFloat, midY: CGFloat) -> CGFloat {
        let radians = location.y < midY
            ? atan2(location.x - midX, midY - location.y)
            : .pi - atan2(location.x - midX, location.y - midY)
        let degrees = radians * 180 / .pi
        return degrees < 0 ? degrees + 360 : degrees
    }
    
    private func calculateAngle(startLocation: CGPoint, currentLocation: CGPoint) -> Double {
        let midX = 300.0 / 2
        let midY = 300.0 / 2
        let startAngle = location2Degrees(location: startLocation, midX: midX, midY: midY)
        let endAngle = location2Degrees(location: currentLocation, midX: midX, midY: midY)
        var newAngle = (endAngle - startAngle) / 360.0

        if 0.0 > newAngle {
            newAngle = 0.01
        } else if newAngle > 1.0 {
            newAngle = 0.99
        }
        
        return newAngle
    }
    
    var body: some View {
        GeometryReader { bounds in
            ZStack {
                Image(systemName: audioManager.currentFile!.iconName)
                    .foregroundStyle(settingsManager.tintColor.color)
                    .font(.system(size: 175, weight: .bold))
                
                Circle()
                    .fill(settingsManager.tintColor.color.tertiary)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(sliderValue, 1.0)))
                    .stroke(settingsManager.tintColor.color ,style: StrokeStyle(lineWidth: 35.0, lineCap: .round, lineJoin: .round))
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: 1.0)
                
                    .gesture(DragGesture(minimumDistance: 0.5, coordinateSpace: .local)
                        .updating($isActive) { value, state, transaction in
                            state = true
                            sliderActive = true
                        }
                        .onChanged({ value in
                            sliderValue = calculateAngle(startLocation: value.startLocation, currentLocation: value.location)
                        })
                            .onEnded({ (value) in
                                sliderValue = calculateAngle(startLocation: value.startLocation, currentLocation: value.location)
                            })
                    )
            }
            
            .frame(maxWidth: 300, maxHeight: 300)
            .onChange(of: isActive) { oldState, newState in
                handler(sliderValue)
            }
        }
    }
}

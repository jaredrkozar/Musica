//
//  CustomButton.swift
//  Musica
//
//  Created by Jared Kozar on 11/24/24.
//

import Foundation
import SwiftUI

struct CustomButton: View {
    @Binding var isScrubbing: Bool
    @Environment(SettingsManager.self) var settingsManager
    
    let iconName: String
    let action: () -> Void
    
    var body: some View {
        Button {
            if !isScrubbing {
                action()
            }
        } label: {
            Image(systemName: iconName)
                .font(.largeTitle)
        }
        .foregroundStyle(settingsManager.tintColor.color)
    }
}

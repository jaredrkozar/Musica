//
//  SettingsView.swift
//  Musica
//
//  Created by Jared Kozar on 9/30/23.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    var color = Color(hue: 90.0, saturation: 34.0, brightness: 20.0)
    @Environment(SettingsManager.self) private var settingsModel
    
    var body: some View {
        @Bindable var settingsModel = settingsModel
        NavigationStack {
            Form {
                ColorPickerCell(currentColor: $settingsModel.tintColor)
                    .buttonStyle(BorderlessButtonStyle())
                Picker("Player View", selection: $settingsModel.playerView) {
                    ForEach(PlayerViewType.allCases) { option in
                            Text(String(describing: option))

                        }
               }
            }
        }
        .navigationTitle("Settings")
    }
}

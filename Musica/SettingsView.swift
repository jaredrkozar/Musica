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
    var body: some View {
        NavigationStack {
            Text("Settings")
        }
        .navigationTitle("Settings")
    }
}

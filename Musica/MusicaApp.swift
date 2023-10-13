//
//  MusicaApp.swift
//  Musica
//
//  Created by Jared Kozar on 9/30/23.
//

import SwiftUI
import SwiftData


@main
struct MusicaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: File.self)
    }
}

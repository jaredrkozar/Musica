//
//  ContentView.swift
//  Musica
//
//  Created by Jared Kozar on 9/30/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        ZStack {
            TabView {
                FileListView()
                    .tabItem {
                        Label("Files", systemImage: "star")
                    }
                SettingsView()
                    .tabItem {
                        Label("Tab2", systemImage: "star")
                    }
            }
            if audioManager.playerState != .noTrack {
                VStack() {
                    Spacer()
                    MiniplayerView()

                }
            }
        }
        
    }
}

#Preview {
    ContentView()
}

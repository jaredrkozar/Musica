//
//  ContentView.swift
//  Musica
//
//  Created by Jared Kozar on 9/30/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(AudioManager.self) private var audioManager
    @Environment(SettingsManager.self) var settingsManager
    @Environment(ViewModel.self) private var viewModel
    @StateObject var sheetCoordinator = SheetCoordinator<ArticleSheet>()
    
    var body: some View {
        ZStack {
            TabView {
                FileListView()
                    .tabItem {
                        Label("Files", systemImage: "list.bullet")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            .tint(settingsManager.tintColor.color)
            
            if audioManager.playerState != .noTrack && viewModel.searchText == "" {
                VStack() {
                    Spacer()
                    MiniplayerView()
                        .onTapGesture {
                            sheetCoordinator.presentSheet(.fullPlayerView)
                        }

                }
            }
        }
        .sheetCoordinator(self.sheetCoordinator)
    }
}

#Preview {
    ContentView()
}

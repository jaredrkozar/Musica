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
    @State private var isTargeted: Bool = false
    
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
                        .dropDestination(for: File.self) { items, location in
                            for item in items {
                                print(item.title)
                                audioManager.playLastInQueue(file: item)
                            }
                             return true
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

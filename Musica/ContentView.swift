//
//  ContentView.swift
//  Musica
//
//  Created by Jared Kozar on 9/30/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var audioManager: AudioManager
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        ZStack {
            TabView {
                FileListView(sort: viewModel.sortMethod, searchString: viewModel.searchText, order: viewModel.sortDirection)
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

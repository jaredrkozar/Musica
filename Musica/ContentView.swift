//
//  ContentView.swift
//  Musica
//
//  Created by Jared Kozar on 9/30/23.
//

import SwiftUI

struct ContentView: View {
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
                VStack {
                    Spacer()
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 70)
                        .foregroundColor(.red)
                        .padding(.bottom, 60)
                }
        }
    }
}

#Preview {
    ContentView()
}

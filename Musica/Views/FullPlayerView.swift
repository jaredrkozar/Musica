//
//  FullPlayerView.swift
//  Musica
//
//  Created by Jared Kozar on 10/4/24.
//

import SwiftUI

struct FullPlayerView: View {
    @Environment(AudioManager.self) private var audioManager
    @Environment(ViewModel.self) private var viewModel
    @StateObject var sheetCoordinator = SheetCoordinator<ArticleSheet>()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 100) {
            VStack {
                FileIcon(color: audioManager.currentFile!.color.color, icon: .standardIcon(iconName: "pin"), iconSize: .large)
                    .foregroundStyle(.green)
                    
                Text(audioManager.currentFile!.title)
                    .truncationMode(.tail)
                    .font(.title3)
                    .bold()
                    .lineLimit(1)
            }
            
            HStack(spacing: 40) {
                Image(systemName: "backward.fill")
                    .font(.largeTitle)
                
                Button {
                    audioManager.togglePlayPause()
                } label: {
                    Image(systemName: audioManager.playerState == .paused ?  "play.fill" : "pause.fill")
                        .font(.largeTitle)
                }
                
                Button {
                    audioManager.fastForward()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.largeTitle)
                }
            }
            
            HStack(spacing: 40) {
                Button {
                    sheetCoordinator.presentSheet(.songInfoView)
                } label: {
                    Image(systemName: "info.circle")
                        .font(.largeTitle)
                }
                
                RouteButtonView()
                    .frame(height: 50)
                
                Button {
                    sheetCoordinator.presentSheet(.upNextView)
                } label: {
                    Image(systemName: "list.bullet")
                        .font(.largeTitle)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheetCoordinator(self.sheetCoordinator)
    }
}

#Preview {
    FullPlayerView()
}

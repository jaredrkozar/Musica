//
//  MiniplayerView.swift
//  Musica
//
//  Created by Jared Kozar on 10/22/23.
//

import Foundation
import SwiftUI

struct MiniplayerView: View {
    @EnvironmentObject var audioManager: AudioManager
    var body: some View {
        HStack {
            Icon(color: audioManager.currentFile.color.color, name: audioManager.currentFile.iconName, iconSize: .medium)
            
            Text(audioManager.currentFile.title)
                .bold()
                .frame(maxWidth: 200, alignment: .leading)
            
            Button {
                audioManager.togglePlayPaused()
            } label: {
                Image(systemName: audioManager.playerState == .paused ?  "play.fill" : "pause.fill")
            }
            .padding(.trailing)
            .buttonStyle(ActionButtonStyle())
            
            Button {
                print("FF")
            } label: {
                Image(systemName: "forward.fill")
            }
            .buttonStyle(ActionButtonStyle())
            
        }
        .frame(maxWidth: .infinity, maxHeight: 70)
        .background(Color(.systemGray5))
        .padding(.bottom, 50)
        .zIndex(1)
    }
}

struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.title2)
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
            .animation(
                            .spring(
                                response: 0.25,
                                dampingFraction: 0.6,
                                blendDuration: 1
                            ),
                            value: configuration.isPressed
                        )
    }
}

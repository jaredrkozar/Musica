//
//  FullPlayerView.swift
//  Musica
//
//  Created by Jared Kozar on 10/4/24.
//

import SwiftUI

struct FullPlayerView: View {
    @Environment(AudioManager.self) var audioManager
    @Environment(SettingsManager.self) var settingsManager
    @StateObject var sheetCoordinator = SheetCoordinator<ArticleSheet>()
    @State var progress: TimeInterval = .zero
    @State var isScrubbing: Bool = false
    
    private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var discViewPlayer: some View {
        return DiscView(sliderValue: $progress, sliderActive: $isScrubbing) { percent in
            isScrubbing = false
            progress = percent
            audioManager.goToTimestamp(time: percent * audioManager.totalDuration)
        }
        .frame(maxHeight: 300)
    }
    
    var scrubberPlayer: some View {
        return VStack {
            FileIcon(color: audioManager.currentFile!.color.color, icon: .standardIcon(iconName: audioManager.currentFile!.iconName), iconSize: .large)
                .foregroundStyle(.green)
            
            VStack {
                CustomSlider(sliderValue: $progress, sliderActive: $isScrubbing) { percent in
                    isScrubbing = false
                    progress = percent
                    audioManager.goToTimestamp(time: percent * audioManager.totalDuration)
                }
                .frame(maxHeight: 15)
                
                HStack {
                    Text("\(audioManager.currentPlaybackTime.convert())")
                    
                    Spacer()
                    
                    Text("-\(audioManager.songTimeRemaining ?? "0:00")")
                }
            }
        }
    }
    
    var body: some View {
        @Bindable var audio = audioManager
        @Bindable var settings = settingsManager
        
        GeometryReader { bounds in
            VStack(alignment: .center) {
                
                switch settings.playerView {
                    case .scrubber:
                        scrubberPlayer
                    case .disc:
                        discViewPlayer
                }
                
                Spacer()
                
                Text(audioManager.currentFile!.title)
                    .truncationMode(.tail)
                    .font(.title3)
                    .bold()
                    .lineLimit(1)
                
                Spacer()
                
                HStack(spacing: 40) {
                    CustomButton(isScrubbing: $isScrubbing, iconName: "backward.fill") {
                        audioManager.rewind()
                    }
                    
                    CustomButton(isScrubbing: $isScrubbing, iconName: audioManager.playerState == .paused ?  "play.fill" : "pause.fill") {
                        audioManager.togglePlayPause()
                    }
                    
                    CustomButton(isScrubbing: $isScrubbing, iconName: "forward.fill") {
                        audioManager.fastForward()
                    }
                }

                Spacer()
                
                HStack(spacing: 40) {
                    CustomButton(isScrubbing: $isScrubbing, iconName: "info.circle") {
                        sheetCoordinator.presentSheet(.songInfoView)
                    }
                    
                    RouteButtonView()
                    
                    CustomButton(isScrubbing: $isScrubbing, iconName: "list.bullet") {
                        sheetCoordinator.presentSheet(.upNextView)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 20)
            }
            .padding(EdgeInsets(top: 20, leading: 24, bottom: 12, trailing: 24))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onReceive(timer) { _ in
            if !isScrubbing {
                progress = audioManager.currentPlaybackTime / audioManager.totalDuration
            }
            audioManager.updateProgress()
        }
        .sheetCoordinator(self.sheetCoordinator)
    }
}

#Preview {
    FullPlayerView()
}

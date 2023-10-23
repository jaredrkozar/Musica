//
//  Player.swift
//  Local Media
//
//  Created by Robert Sandru on 5/10/20.
//  Copyright © 2020 codecontrive. All rights reserved.
//

import AVFoundation
import Combine
import MediaPlayer

enum PlayerState {
    case playing
    case paused
    case noTrack
}

class AudioManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    @Published var playerState: PlayerState = .noTrack
    
    var player = AVAudioPlayer()
    
    private var file: File?
    
    public var currentFile: File? {
         get {
             return self.file;
         }
         set {
             file = newValue
             play(with: URL(filePath: (newValue?.returnFilePath())!, directoryHint: .notDirectory, relativeTo: .documentsDirectory))
         }
     }
    
    private func play(with url: URL) {
        do {
            let isReachable = try url.checkResourceIsReachable()
            if isReachable {
                self.player = try AVAudioPlayer(contentsOf: url)
                self.player.prepareToPlay()
                self.player.volume = 1.0
                self.player.delegate = self
                self.playerState = .playing
                let audioSession = AVAudioSession.sharedInstance()
                do {
                    try audioSession.setCategory(.playback, mode: .default, options: [])
                    try audioSession.setActive(true)
                } catch let error {
                    print("Error setting up audio session: \(error.localizedDescription)")
                }

                self.player.play()
                setupNowPlaying()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public func togglePlayPaused() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
        self.playerState == .playing ? pause() : unpause()
    }
    
    private func pause() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
        
        player.pause()
        playerState = .paused
    }
    
    private func unpause() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
        player.play()
        playerState = .playing
    }
    
    func stop() {
        player.stop()
        playerState = .noTrack
    }
    
    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = file?.title

        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        
        MPRemoteCommandCenter.shared().playCommand.isEnabled = true
        MPRemoteCommandCenter.shared().playCommand.addTarget(handler: play)
        
        MPRemoteCommandCenter.shared().pauseCommand.isEnabled = true
        MPRemoteCommandCenter.shared().pauseCommand.addTarget(handler: pause)
        
        MPRemoteCommandCenter.shared().togglePlayPauseCommand.isEnabled = true
        MPRemoteCommandCenter.shared().togglePlayPauseCommand.addTarget(handler: togglePlayPause)
        
        MPRemoteCommandCenter.shared().changePlaybackPositionCommand.isEnabled = true
        MPRemoteCommandCenter.shared().changePlaybackPositionCommand.addTarget(handler: changeTimestamp)
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        MPNowPlayingInfoCenter.default().playbackState = .playing
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    func play(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        unpause()
         // Handle remote event by updating your app's state here
         return .success // or .commandFailed
    }
    
    func pause(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        pause()
         // Handle remote event by updating your app's state here
         return .success // or .commandFailed
    }
    
    func togglePlayPause(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        togglePlayPaused()
         // Handle remote event by updating your app's state here
         return .success // or .commandFailed
    }
    
    func changeTimestamp(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        if let event = event as? MPChangePlaybackPositionCommandEvent {
            player.currentTime = event.positionTime
                }
        
         // Handle remote event by updating your app's state here
         return .success // or .commandFailed
    }
}

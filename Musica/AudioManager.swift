//
//  Player.swift
//  Local Media
//
//  Created by Robert Sandru on 5/10/20.
//  Copyright © 2020 codecontrive. All rights reserved.
//

import AVFoundation
import Combine

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
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                 try AVAudioSession.sharedInstance().setActive(true)
                
                self.player.play()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public func togglePlayPaused() {
        self.playerState == .playing ? pause() : unpause()
    }
    
    private func pause() {
        player.pause()
        playerState = .paused
    }
    
    private func unpause() {
        player.play()
        playerState = .playing
    }
    
    func stop() {
        player.stop()
        playerState = .noTrack
    }
}

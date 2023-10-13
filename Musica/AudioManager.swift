//
//  Player.swift
//  Local Media
//
//  Created by Robert Sandru on 5/10/20.
//  Copyright © 2020 codecontrive. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import Combine

enum PlayerState {
    case playing
    case paused
    case noTrack
}

class AudioManager: ObservableObject {
    
    @Published var playerState: PlayerState = .noTrack
    
    var player: AVAudioPlayer!
    
    func play(playable: URL) {

        do {
//            try AVAudioSession.sharedInstance().setCategory(.playback)
//            try AVAudioSession.sharedInstance().setActive(true)
            if playerState == .playing {
                player.stop()
            }
            
            player = try AVAudioPlayer(contentsOf: playable)
            player.volume = 1.0
            player.prepareToPlay()
            player.play()
            playerState = .playing
        } catch {
            print("The track isnt playing right now")
            playerState = .noTrack
        }
    }
    
    func pause() {
        player.pause()
        playerState = .paused
    }
    
    func unpause() {
        player.play()
        playerState = .playing
    }
    
    func stop() {
        player.stop()
        playerState = .noTrack
    }
    
    func toggle() {
        if (playerState == .playing) {
            pause()
        } else if (playerState == .paused) {
            unpause()
        }
    }
}

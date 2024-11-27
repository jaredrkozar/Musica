//
//  Player.swift
//  Local Media
//
//  Created by Robert Sandru on 5/10/20.
//  Copyright © 2020 codecontrive. All rights reserved.
//

import AVFoundation
import MediaPlayer
import Observation
import SwiftUI

enum PlayerState {
    case playing
    case paused
    case noTrack
}

@Observable class AudioManager: NSObject, AVAudioPlayerDelegate {
   
    var playerState: PlayerState = .noTrack
    
    var player: AVAudioPlayer
    
    var currentFile: File? {
        didSet {
            play(file: currentFile!)
        }
    }
    
    var fileQueue = [File]()
    
    var repeatSong: Bool = false {
        didSet {
            player.numberOfLoops = repeatSong == true ? -1 : 1
        }
    }
    
    
    var percentThroughSong: TimeInterval {
        get {
            return currentPlaybackTime / totalDuration
        } set {
            player.pause()
            goToTimestamp(time: newValue * totalDuration)
        }
    }
    
    var totalDuration: TimeInterval {
        player.duration
    }

    var currentPlaybackTime: TimeInterval {
        get {
            return player.currentTime
        } set {
            player.currentTime = newValue
        }
    }
    
    var songTimeRemaining: String?
    
    override init() {
        player = AVAudioPlayer()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
        } catch let error {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
    }
    
    private func play(file: File) {
        let url = file.path.returnDocumentsURL()
        do {
            let isReachable = try url.checkResourceIsReachable()
            if isReachable {
                self.player = try AVAudioPlayer(contentsOf: url)
                self.player.prepareToPlay()
                self.player.volume = 1.0
                self.player.delegate = self
                playSong()
                
                setupNowPlaying()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public func togglePlayPauseCommand(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        togglePlayPause()
        return .success
    }
    
    func togglePlayPause() {
        switch playerState {
        case .playing:
            pauseSong()
        case .paused ,.noTrack:
            playSong()
        }
    }
    
    func playSong() {
        player.play()
        playerState = .playing
    }
    
    func pauseSong() {
        player.pause()
        playerState = .paused
    }
    
    func stopSong() {
        player.stop()
        playerState = .noTrack
    }
    
    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = currentFile?.title

        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentPlaybackTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = totalDuration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        
        let systemControls = MPRemoteCommandCenter.shared()
        systemControls.playCommand.isEnabled = true
        systemControls.playCommand.addTarget(handler: playSongCommand(event:))
        
        systemControls.pauseCommand.isEnabled = true
        systemControls.pauseCommand.addTarget(handler: pauseSongCommand(event:))
        
        systemControls.togglePlayPauseCommand.isEnabled = true
        systemControls.togglePlayPauseCommand.addTarget(handler: togglePlayPauseCommand(event:))
        
        systemControls.changePlaybackPositionCommand.isEnabled = true
        systemControls.changePlaybackPositionCommand.addTarget(handler: changeTimestamp)
        
        systemControls.nextTrackCommand.isEnabled = true
        systemControls.nextTrackCommand.addTarget(handler: fastForwardCommand)
        
        systemControls.previousTrackCommand.isEnabled = true
        systemControls.previousTrackCommand.addTarget(handler: rewindCommand)
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        MPNowPlayingInfoCenter.default().playbackState = .playing
        
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(handleInterruption),
                       name: AVAudioSession.interruptionNotification,
                       object: AVAudioSession.sharedInstance())
    }
    
    @objc func handleInterruption() {
        pauseSong()
    }
    
    func playSongCommand(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        playSong()
        
         // Handle remote event by updating your app's state here
         return .success // or .commandFailed
    }
    
    func pauseSongCommand(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        pauseSong()
        
         // Handle remote event by updating your app's state here
         return .success // or .commandFailed
    }
    
    func fastForwardCommand(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        fastForward()
        
         // Handle remote event by updating your app's state here
         return .success // or .commandFailed
    }
    
    func rewindCommand(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        rewind()
        
         // Handle remote event by updating your app's state here
         return .success // or .commandFailed
    }
    
    func changeTimestamp(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {

        if let event = event as? MPChangePlaybackPositionCommandEvent {
            print("changed timestamp to \(event.positionTime)")
            goToTimestamp(time: event.positionTime)
        }
        
         // Handle remote event by updating your app's state here
         return .success // or .commandFailed
    }
    
    
    func playNextInQueue(file: File) {
        fileQueue.insert(file, at: 0)
    }
    
    func playLastInQueue(file: File) {
        fileQueue.append(file)
    }
    
    func moveItemInQueue(fromIndex: IndexSet, toIndex: Int) {
        fileQueue.move(fromOffsets: fromIndex, toOffset: toIndex)
    }
    
    func removeFromQueue(index: IndexSet) {
        fileQueue.remove(atOffsets: index)
    }
    
    func rewind() {
        player.stop()
        playerState = .playing
        goToTimestamp(time: 0)
    }
    
    func fastForward() {
        if !fileQueue.isEmpty {
            currentFile = fileQueue.removeFirst()
            playSong()
        }
    }
    
    func updateProgress() {
        let time = totalDuration - currentPlaybackTime
        songTimeRemaining = time.convert()
    }
    
    func goToTimestamp(time: TimeInterval) {
        currentPlaybackTime = time
        MPNowPlayingInfoCenter.default().nowPlayingInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] = time
        if playerState == .playing {
            playSong()
        }
    }
    
    func shuffleSongs() {
        fileQueue = fileQueue.shuffled()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if repeatSong == false && !fileQueue.isEmpty {
            fastForward()
            return
        }
        
        pauseSong()
    }
}

func runningInExtension() -> Bool {
    let bundleUrl: URL = Bundle.main.bundleURL
    let bundlePathExtension: String = bundleUrl.pathExtension
    let isAppex: Bool = bundlePathExtension == "appex"
    return isAppex
}

extension TimeInterval {
    func convert() -> String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

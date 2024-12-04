//
//  SettingsManager.swift
//  Musica
//
//  Created by Jared Kozar on 12/3/24.
//

import Foundation
import Observation

enum PlayerViewType: CaseIterable, Identifiable {
    case disc
    case scrubber
    
    var id: Self { self }


}

@Observable class SettingsManager: NSObject {
    var playerView: PlayerViewType = .scrubber
    
    var tintColor: CustomColors = .blue
}

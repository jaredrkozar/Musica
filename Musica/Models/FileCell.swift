//
//  FileCell.swift
//  Musica
//
//  Created by Jared Kozar on 9/30/23.
//

import Foundation
import SwiftUI

struct FileCell: View {
    var file: File
    @Environment(AudioManager.self) private var audioManager
    @State var showFullScreenPlayer: Bool = false
    
    var isCurrentEpisode: Bool {
        return file.title == audioManager.currentFile?.title
    }
    
    var body: some View {
        HStack {
            ZStack {
                FileIcon(color: file.color.color, icon: isCurrentEpisode ? .currentlyPlaying : .standardIcon(iconName: file.iconName), iconSize: .small)
            }
            
            VStack(alignment: .leading) {
                Text(file.title)
                    .fontWeight(isCurrentEpisode ? .medium : .regular)
                
                Text(file.dateAdded, style: .date)
                    .foregroundStyle(.gray)
                    .fontWeight(isCurrentEpisode ? .medium : .regular)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}

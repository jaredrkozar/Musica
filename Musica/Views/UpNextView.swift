//
//  UpNextView.swift
//  Musica
//
//  Created by Jared Kozar on 11/20/24.
//

import SwiftUI

struct UpNextView: View {
    @Environment(AudioManager.self) private var audioManager
    
    var body: some View {
        NavigationStack {
            List {
                if audioManager.fileQueue.isEmpty {
                    ContentUnavailableView("No Songs in Queue", systemImage: "waveform.slash", description: Text("Add songs to the queue by swiping right on a file"))
                } else {
                    ForEach(audioManager.fileQueue, id: \.self) { file in
                        FileCell(file: file)
                    }
                    .onMove { from, to in

                        audioManager.moveItemInQueue(fromIndex: from, toIndex: to)
                    }
                }
            }
            .toolbar {
                 EditButton()
             }
            .navigationTitle("Queue")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    UpNextView()
}

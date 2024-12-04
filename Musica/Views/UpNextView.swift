//
//  UpNextView.swift
//  Musica
//
//  Created by Jared Kozar on 11/20/24.
//

import SwiftUI

struct UpNextView: View {
    @Environment(AudioManager.self) private var audioManager
    @Environment(SettingsManager.self) var settingsManager
    @State var showClearQueueAlert: Bool = false
    
    var upNextQueue: some View {
        return VStack {
            HStack {
                Text("Up Next")
                    .bold()
                    .font(.title3)
                
                Spacer()
                
                Button(role: .destructive) {
                    showClearQueueAlert = true
                } label: {
                    Text("Clear")
                }
            }
    
            List {
                ForEach(audioManager.fileQueue, id: \.self) { file in
                    FileCell(file: file)
                }
                .onMove { from, to in
                    audioManager.moveItemInQueue(fromIndex: from, toIndex: to)
                }
                .onDelete { indexSet in
                    audioManager.removeFromQueue(index: indexSet)
                }
            }
        }
        .alert("Are you sure you want to clear your queue?", isPresented: $showClearQueueAlert) {
            Button("Clear Queue", role: .destructive) {
                audioManager.clearQueue()
            }
            Button("OK", role: .cancel) { }
        }
    }
    var body: some View {
        @Bindable var audio = audioManager
        NavigationStack {
            VStack {
                Text("Current song: \(audioManager.currentFile!.title)")
                    .bold()
                    .font(.title3)
                
                HStack {
                    Button {
                        audioManager.shuffleSongs()
                    } label: {
                        Label("Shuffle", systemImage: "shuffle")
                    }
                    .buttonStyle(UpNextButtonStyle())
                    .foregroundColor(settingsManager.tintColor.color)
                    .background(settingsManager.tintColor.color.quaternary)
                    .cornerRadius(16)
                    
                    Spacer()
                    
                    Button {
                        audio.repeatSong.toggle()
                    } label: {
                        Label("Repeat", systemImage: "repeat.1")
                    }
                    .buttonStyle(UpNextButtonStyle())
                    .foregroundColor(settingsManager.tintColor.color)
                    .background(audio.repeatSong ? Color.blue.quaternary : Color.clear.quaternary)
                    .cornerRadius(16)
                }
            }
                
            if audioManager.fileQueue.isEmpty {
                ContentUnavailableView("No Songs in Queue", systemImage: "waveform.slash", description: Text("Add songs to the queue by swiping right on a file"))
            } else {
                upNextQueue
            }
            
        }
        .navigationTitle("Queue")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
             EditButton()
                .disabled(audioManager.fileQueue.isEmpty)
                .foregroundStyle(settingsManager.tintColor.color)
         }
    }
}

struct UpNextButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(16)
            .frame(height: 48)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

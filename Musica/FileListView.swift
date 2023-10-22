//
//  FileListView.swift
//  Musica
//
//  Created by Jared Kozar on 9/30/23.
//

import Foundation
import SwiftUI
import SwiftData

struct FileListView: View {
    @Query var files: [File]
    @State var selectedFile: File?
    @StateObject var model = FileListModel()
    @EnvironmentObject var audioManager: AudioManager
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            List(files) { file in
                FileCell(file: file, isCurrentFile: $audioManager.currentFile)
                    .onTapGesture {
                        audioManager.currentFile = file
                    }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button(role: .none) {
                        model.presentedSheet = .editFile(file: file)
                    } label: {
                        Label("Edit", systemImage: "pencil.line")
                    }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        do {
                            try FileManager.default.removeItem(at: URL(filePath: file.returnFilePath(), directoryHint: .notDirectory, relativeTo: .documentsDirectory))
                        } catch let error {
                            print("Error: \(error.localizedDescription)")
                        }
                        
                        modelContext.delete(file)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
           }
            
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        model.showFileImportMenu = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            
            .fileImporter(isPresented: $model.showFileImportMenu,
                          allowedContentTypes: [.audio]) { result in
                
                switch result {
                case .success(let url):
                    model.presentedSheet = .addFile(url: url)
                    break
                case .failure(let error):
                    model.error = error.localizedDescription
                    model.showError = true
                    break
                }
                
             }
          .sheet(item: $model.presentedSheet) {
              print("Sheet dismissed!")
          } content: { sheet in
              switch sheet {
              case .addFile(url: let url):
                  CreateFileView(name: url.deletingPathExtension().lastPathComponent, iconName: "pin", iconColor: .red, filePath: url)
                      .presentationDetents([.medium])
              case .editFile(file: let file):
                  EditFileView(file: file)
                      .presentationDetents([.medium])
              }
            }
            
            .alert("An error occured", isPresented: $model.showError) {
                 Button("OK", role: .cancel) {
            
                 }
            } message: {
                Text(model.error)
            }
            
           .navigationTitle("Files")
        }
    }
}

class FileListModel: ObservableObject {
    var error: String = ""
    var showError: Bool = false
    
    @Published var showFileImportMenu: Bool = false
    
    enum Sheet: Hashable, Identifiable {
        
        case addFile(url: URL)
        case editFile(file: File)
        
          var id: Self {

              return self
          }
    }
    
    @Published var presentedSheet: Sheet?
}

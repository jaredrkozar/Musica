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
    @Environment(ViewModel.self) private var viewModel
    @EnvironmentObject var audioManager: AudioManager
    @Environment(\.modelContext) var modelContext
    
    init(sort: SortMethods = .title, searchString: String = "", order: SortOrder = .forward) {
        let predicate = File.predicate(searchText: searchString)
        
        switch sort {
        case .title:
            _files = Query(filter: predicate, sort: \.title, order: order)
        case .date:
            _files = Query(filter: predicate, sort: \.dateAdded, order: order)
        }
    }
    
    var body: some View {
        @Bindable var model = viewModel
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
                    .tint(.blue)
                    
                    ShareLink(item: URL(filePath: file.returnFilePath(), directoryHint: .notDirectory, relativeTo: .documentsDirectory), subject: Text(file.title.removingPercentEncoding!)) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    .tint(.orange)
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
            .overlay {
                if !model.searchText.isEmpty && files.isEmpty {
                    ContentUnavailableView.search
                } else if files.isEmpty {
                    ContentUnavailableView("No Files Found", systemImage: "waveform.slash", description: Text("Add some files by using +"))
                }
            }
            .searchable(text: $model.searchText, placement: .toolbar, prompt: Text("Serch files"))
            
            .toolbar {
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    SortfilesButton()
                    
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

extension File {
    static func predicate(
        searchText: String
    ) -> Predicate<File> {

        return #Predicate<File> { quake in
            (searchText.isEmpty || quake.title.contains(searchText))
        }
    }
}

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
    @Environment(ViewModel.self) private var viewModel
    @Environment(AudioManager.self) private var audioManager
    @Environment(\.modelContext) var modelContext
    @StateObject var sheetCoordinator = SheetCoordinator<ArticleSheet>()
    @State var selectedFiles = Set<File>()
    @State var sort: SortMethods = .title
    @State var order: SortOrder = .reverse
    @Environment(SettingsManager.self) var settingsManager
    
    init() {
//        print(sort)
//        print(order)
//        let predicate = File.predicate(searchText: viewModel.searchText)
//        _files = Query(sort: \.title, order: order)
//        print(files)
//        switch sort {
//        case .title:
//            _files = Query(filter: predicate, sort: \.title, order: order)
//        case .date:
//            _files = Query(filter: predicate, sort: \.dateAdded, order: order)
//        }
    }
    
    var body: some View {
        @Bindable var model = viewModel
        
        NavigationStack {
            List(files, id: \.id, selection: $selectedFiles) { file in
                FileCell(file: file)
                    .draggable(file)
                    .onTapGesture {
                        audioManager.currentFile = file
                    }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button(role: .none) {
                        audioManager.playNextInQueue(file: file)
                    } label: {
                        Label("Play Next", systemImage: "text.insert")
                    }
                    .tint(.blue)
                    
                    Button(role: .none) {
                        audioManager.playLastInQueue(file: file)
                    } label: {
                        Label("Play Last", systemImage: "text.append")
                    }
                    .tint(.orange)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    
                    Button(role: .destructive) {
                        do {
                            try FileManager.default.removeItem(at: file.path.returnDocumentsURL())
                        } catch let error {
                            print("Error: \(error.localizedDescription)")
                        }
                        
                        modelContext.delete(file)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    
                    Button(role: .none) {
                        sheetCoordinator.presentSheet(.editFile(File: file))
                    } label: {
                        Label("Edit", systemImage: "pencil.line")
                    }
                    .tint(.green)
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
                    Menu {
                        Picker("Sort Order", selection: $order) {
                            ForEach([SortOrder.forward, SortOrder.reverse], id: \.self) { order in
                                Text(order.name)
                            }
                        }
                        Picker("Sort By", selection: $sort) {
                            ForEach(SortMethods.allCases, id: \.self) { parameter in
                                Text(parameter.asString)
                            }
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                    .pickerStyle(.automatic)
                    .tint(settingsManager.tintColor.color)
                    
                    Button {
                        model.showFileImportMenu = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .foregroundStyle(settingsManager.tintColor.color)
                }
            }
            
            .fileImporter(isPresented: $model.showFileImportMenu,
                          allowedContentTypes: [.audio]) { result in
                
                switch result {
                case .success(let url):
                    sheetCoordinator.presentSheet(.addFile(url: url))
                    break
                case .failure(let error):
                    model.error = error.localizedDescription
                    model.showError = true
                    break
                }
                
             }
            
            .alert("An error occured while importing the file", isPresented: $model.showError) {
                 Button("OK", role: .cancel) {
                 }
            } message: {
                Text(model.error)
            }
           .navigationTitle("Files")
           .sheetCoordinator(self.sheetCoordinator)
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

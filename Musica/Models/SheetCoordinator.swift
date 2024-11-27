//
//  SheetCoordinator.swift
//  Musica
//
//  Created by Jared Kozar on 11/22/24.
//

import SwiftUI

final class SheetCoordinator<Sheet: SheetEnum>: ObservableObject {
    @Published var currentSheet: Sheet?
    private var sheetStack: [Sheet] = []
    
    @MainActor
    func presentSheet(_ sheet: Sheet) {
        sheetStack.append(sheet)
        
        if sheetStack.count == 1 {
            currentSheet = sheet
        }
    }
    
    @MainActor
    func sheetDismissed() {
        sheetStack.removeFirst()
        
        if let nextSheet = sheetStack.first {
            currentSheet = nextSheet
        }
    }
}

protocol SheetEnum: Identifiable {
    associatedtype Body: View
    
    @ViewBuilder
    func view(coordinator: SheetCoordinator<Self>) -> Body
}

internal enum ArticleSheet: SheetEnum {
    case addFile(url: URL)
    case editFile(File: File)
    case fullPlayerView
    case upNextView
    case songInfoView
    
    public var id: String {
        switch self {
        case .addFile:
            "addFile"
        case .editFile:
            "editFile"
        case .fullPlayerView:
            "fullPlayerView"
        case .upNextView:
            "upNextView"
        case .songInfoView:
            "songInfoView"
        }
    }
    
    @ViewBuilder
    func view(coordinator: SheetCoordinator<ArticleSheet>) -> some View {
        switch self {
        case .addFile(let url):
            CreateFileView(name: url.deletingPathExtension().lastPathComponent, iconName: "music.note", iconColor: .red, filePath: url)
                .presentationDetents([.medium])
        case .editFile(let file):
            EditFileView(file: file)
                .presentationDetents([.medium])
        case .songInfoView:
            SongInfoView()
                .presentationDetents([.medium])
        case .fullPlayerView:
            FullPlayerView()
                .presentationDetents([.large])
        case .upNextView:
            UpNextView()
                .presentationDetents([.medium])
        }
    }
}

struct SheetCoordinating<Sheet: SheetEnum>: ViewModifier {
    @StateObject var coordinator: SheetCoordinator<Sheet>
    
    func body(content: Content) -> some View {
        content
            .sheet(item: $coordinator.currentSheet, onDismiss: { coordinator.sheetDismissed() }) { sheet in
                sheet.view(coordinator: coordinator)
            }
        
    }
}

extension View {
    func sheetCoordinator<Sheet: SheetEnum>(_ coordinator: SheetCoordinator<Sheet>) -> some View {
        modifier(SheetCoordinating(coordinator: coordinator))
    }
}

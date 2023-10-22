//
//  EditFileView.swift
//  Musica
//
//  Created by Jared Kozar on 9/30/23.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct EditFileView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var file: File
    @Environment(\.dismiss) var dismiss
    @State var customColor: CustomColors = .red
    
    var body: some View {
    
        NavigationStack {
            FilePropertiesView(fileTitle: $file.title, fileColor: $file.color, fileIcon: $file.iconName)
            
            .buttonStyle(BorderlessButtonStyle())
            .navigationTitle("Edit File Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            .accentColor(file.color.color)
        }
    }
}

struct CreateFileView: View {
    @Environment(\.modelContext) var modelContext
    @State var name: String = ""
    @State var iconName: String = "pin"
    @State var iconColor: CustomColors = .red
    @State var filePath: URL
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            FilePropertiesView(fileTitle: $name, fileColor: $iconColor, fileIcon: $iconName)
            .buttonStyle(BorderlessButtonStyle())
            .navigationTitle("File Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button {
                        let newFile = File(title: name, path: filePath.convertToCorrectPath(), color: iconColor, iconName: iconName)
                        modelContext.insert(newFile)
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                    .disabled(name.isEmpty)
                }
                
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            .accentColor(iconColor.color)
        }
    }
}

struct FilePropertiesView: View {
    @Binding var fileTitle: String
    @Binding var fileColor: CustomColors
    @Binding var fileIcon: String
    
    var body: some View {
        List {
            TextCell(currentValue: $fileTitle, placeholder: "Enter FIle Name", leftText: "File Name")
            
            Section {
                ColorPickerCell(currentColor: $fileColor)
                
            } header: {
                Text("Appearance")
            }
        }
    }
}

extension URL {
    
    static var documentDirectory: URL {
        return FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func convertToCorrectPath() -> String {
        let destinationURL = URL.documentDirectory.appendingPathComponent(self.lastPathComponent, conformingTo: self.pathExtension.getExtension())
        let canAccessURL = self.startAccessingSecurityScopedResource()
        if canAccessURL {
            do {
                try FileManager.default.copyItem(at: self, to: destinationURL)
                self.stopAccessingSecurityScopedResource()
            } catch (let error) {
                print("Cannot copy item to directory: \(error)")
            }
        } else {
            print("You cannot access this URL right now")
        }
        print("Destination URL \(destinationURL.absoluteString)")
        return destinationURL.absoluteString

    }
}

extension String {
    func getExtension() -> UTType {
        switch self {
        case "mp3":
            return .mp3
        case "wav":
            return .wav
        default:
            return .mp3
        }
    }
}

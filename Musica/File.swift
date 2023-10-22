//
//  File.swift
//  Musica
//
//  Created by Jared Kozar on 9/30/23.
//

import Foundation
import SwiftData

@Model
class File {
    var title: String
    var dateAdded: Date
    var path: String
    var color: CustomColors
    var iconName: String
    
    init(title: String, path: String, color: CustomColors, iconName: String) {
        self.title = title
        self.dateAdded = Date()
        self.path = path
        self.color = color
        self.iconName = iconName
    }
}

extension File {
    func returnFilePath() -> String {
        return URL(filePath: path, directoryHint: .notDirectory, relativeTo: .documentsDirectory).lastPathComponent.removingPercentEncoding!
    }
}

extension File: Equatable {
    
}

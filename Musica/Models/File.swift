//
//  File.swift
//  Musica
//
//  Created by Jared Kozar on 9/30/23.
//

import Foundation
import SwiftData

@Model
class File: Identifiable {
    var title: String
    var dateAdded: Date
    var path: String
    var color: CustomColors
    var iconName: String
    
    //song data
    var gameSeries: String?
    var gameName: String?
    var composerName: String?
    
    init(title: String, path: String, color: CustomColors, iconName: String, gameSeries: String, gameName: String, composerName: String) {
        self.title = title
        self.dateAdded = Date()
        self.path = path
        self.color = color
        self.iconName = iconName
        self.gameSeries = gameSeries
        self.gameName = gameName
        self.composerName = composerName
    }

}

extension String {
    func returnDocumentsURL() -> URL {
        return URL(filePath: self, directoryHint: .notDirectory, relativeTo: .documentsDirectory)
    }
}

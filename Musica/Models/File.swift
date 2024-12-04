//
//  File.swift
//  Musica
//
//  Created by Jared Kozar on 9/30/23.
//

import Foundation
import SwiftData
import CoreTransferable
import UniformTypeIdentifiers

@Model
class File: Codable, Identifiable, Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .musicType)
    }
    
    enum CodingKeys: CodingKey {
        case dateAdded
        case path
        case color
        case title
        case iconName
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        color = try container.decode(CustomColors.self, forKey: .color)
        title = try container.decode(String.self, forKey: .title)
        dateAdded = try container.decode(Date.self, forKey: .dateAdded)
        path = try container.decode(URL.self, forKey: .path).absoluteString
        iconName = try container.decode(String.self, forKey: .iconName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(color, forKey: .color)
        try container.encode(title, forKey: .title)
        try container.encode(dateAdded, forKey: .dateAdded)
        try container.encode(path, forKey: .path)
        try container.encode(iconName, forKey: .iconName)
    }
    
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

extension UTType {
    static let musicType = UTType(exportedAs: "com.jkozar.Musica")
}

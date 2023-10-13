//
//  SwiftData.swift
//  Musica
//
//  Created by Jared Kozar on 10/1/23.
//

import Foundation
import SwiftUI

struct SwiftDataStack {
    @Environment(\.modelContext) var modelContext
    
    func saveFile(file: File) {
        modelContext.insert(file)
    }
}

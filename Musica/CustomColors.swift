//
//  CustomColors.swift
//  Musica
//
//  Created by Jared Kozar on 10/1/23.
//

import Foundation
import UIKit
import SwiftUI

enum SortMethods: String, CaseIterable {
    case title
    case date
    
    var asString: String { return self.rawValue.capitalized }
}

enum CustomColors: Codable, CaseIterable, Identifiable {
    var id: Self {
          return self
      }
    
    // Supported colors

    case red
    case orange
    case yellow
    case green
    case blue
    case cyan
    case teal
    case purple
    case indigo
    case pink
    case brown
    case gray
    
    // light mode colors that dark mode colors are generated from
    var color: Color {
        switch self {
        case .red:
            return .red
        case .orange:
            return .orange
        case .yellow:
            return .yellow
        case .green:
            return .green
        case .blue:
            return .blue
        case .cyan:
            return .cyan
        case .teal:
            return .teal
        case .indigo:
            return .indigo
        case .purple:
            return .purple
        case .pink:
            return .pink
        case .brown:
            return .brown
        case .gray:
            return .gray
        }
    }
    
    public func isMatchingColor(color: CustomColors) -> Bool {
        return color == self
    }

    
    /// Accessibility label for color
    var name: String {
        switch self {
        case .gray:
            return "Gray"
        case .red:
            return "Red"
        case .orange:
            return "Orange"
        case .yellow:
            return "Yellow"
        case .green:
            return "Green"
        case .blue:
            return "Blue"
        case .purple:
            return "Purple"
        case .brown:
            return "Brown"
        case .pink:
            return "Pink"
        case .indigo:
            return "Indigo"
        case .cyan:
            return "Cyan"
        case .teal:
            return "Teal"
        }
    }
    
}

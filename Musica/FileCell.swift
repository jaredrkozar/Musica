//
//  FileCell.swift
//  Musica
//
//  Created by Jared Kozar on 9/30/23.
//

import Foundation
import SwiftUI

struct FileCell: View {
    var file: File
    
    var body: some View {
        HStack {
            ZStack {
                Icon(color: file.color.color, name: file.iconName, iconSize: .small)
            }
            
            VStack(alignment: .leading) {
                Text(file.title)
                
                Text(file.dateAdded, style: .date)
                    .foregroundStyle(.gray)
            }
        }
        .contentShape(Rectangle())
    }
}

struct Icon: View {
    var color: Color
    var name: String
    var iconSize: IconSize
    
    enum IconSize: CGFloat {
        case small
        case medium
        case large
        
        var rectangleWidthHeight: CGFloat {
            switch self {
            case .small:
                return 40.0
            case .medium:
                return 55.0
            case .large:
                return 100.0
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .small:
                return 25.0
            case .medium:
                return 35.0
            case .large:
                return 65.0
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .small:
                return 7.0
            case .medium:
                return 12.0
            case .large:
                return 25.0
            }
        }
    }
    
    var body: some View {
        ZStack {
            Image(systemName: name)
                .foregroundStyle(color)
                .aspectRatio(contentMode: .fit)
                .fontWeight(.semibold)
                .font(.system(size: iconSize.iconSize, weight: .light))
            
            RoundedRectangle(cornerRadius: iconSize.cornerRadius)
                .foregroundStyle(color)
                .opacity(0.2)
        }
        .frame(width: iconSize.rectangleWidthHeight, height: iconSize.rectangleWidthHeight, alignment: .leading)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Icon(color: .red, name: "pin", iconSize: .medium)
            Icon(color: .orange, name: "pin", iconSize: .medium)
            Icon(color: .yellow, name: "pin", iconSize: .medium)
            Icon(color: .green, name: "pin", iconSize: .medium)
            Icon(color: .blue, name: "pin", iconSize: .medium)
            Icon(color: .purple, name: "pin", iconSize: .medium)
            Icon(color: .gray, name: "pin", iconSize: .medium)
        }
    }
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

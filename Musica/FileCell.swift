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
                Icon(color: file.color.color, name: file.iconName)
            }
            .frame(width: 40.0, height: 40.0, alignment: .leading)
            
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
    
    var body: some View {
        ZStack {
            Image(systemName: name)
                .foregroundStyle(color)
                .aspectRatio(contentMode: .fit)
                .fontWeight(.semibold)
            
            RoundedRectangle(cornerRadius: 7.0)
                .foregroundStyle(color)
                .opacity(0.2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Icon(color: .red, name: "pin")
            Icon(color: .orange, name: "pin")
            Icon(color: .yellow, name: "pin")
            Icon(color: .green, name: "pin")
            Icon(color: .blue, name: "pin")
            Icon(color: .purple, name: "pin")
            Icon(color: .gray, name: "pin")
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

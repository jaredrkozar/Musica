//
//  SelectFileIconView.swift
//  Musica
//
//  Created by Jared Kozar on 10/1/23.
//

import Foundation
import SwiftUI

struct SelectFileIconView: View {
    
    @Binding var currentIcon: String
    @State private var searchText = ""
    @State var iconColor: Color
    
    var body: some View {
        Text("DLDLD")
    }
}

struct SymbolCell: View {
    @Binding var currentIcon: String
    @State var image: String
    @Binding var iconColor: Color
    
    var body: some View {
        Button {
            currentIcon = image
        } label: {
            Image(systemName: image)
                .font(.system(size: 45, weight: .medium))
                .padding(15)
        }
        .cornerRadius(15.0)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(iconColor, lineWidth: currentIcon == image ? 4.0 : 0.0)
                .background(currentIcon == image ? iconColor.opacity(0.25) : .clear)
        )
    }
}



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
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 75), alignment: .top)]) {
                
                ForEach(allSymbols) { symbolSection in
                    let filteredSymbols = symbolSection.symbols.filter({symbol in searchText.isEmpty ? true : symbol.lowercased().contains(searchText.lowercased())})
                    
                    Section(header: Text(symbolSection.sectionName).font(.title)) {
                        ForEach(filteredSymbols, id: \.self) { symbolItem in
                            SymbolCell(currentIcon: $currentIcon, image: symbolItem, iconColor: $iconColor)
                                .fixedSize()
                        }
                    
                 }
                }
            }
        }
        .accentColor(iconColor)
        .searchable(text: $searchText)
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



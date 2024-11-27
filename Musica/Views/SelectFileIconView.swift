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
    @State var selectedFilter: IconFilter?
    
    var body: some View {
        ScrollView(.horizontal) {
            ForEach(icons) { icon in
                Button {
                    selectedFilter = icon
                } label: {
                    IconFilterCell(filter: icon, activeFilter: $selectedFilter, iconColor: iconColor)
                }
            }
        }
    }
}

struct IconFilterCell: View {
    var filter: IconFilter
    @Binding var activeFilter: IconFilter?
    @State var iconColor: Color
    
    private var isFilterSelected: Bool {
        return filter.filterName == activeFilter?.filterName
    }
    
    var body: some View {
        HStack {
            Text(filter.filterName)
                .foregroundStyle(isFilterSelected ? .white : iconColor)
            
            Image(systemName: filter.filterIcon)
                .foregroundColor(iconColor)
        }
        .background(isFilterSelected ? iconColor : .clear)
        .padding(10)
        .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(iconColor, lineWidth: 4)
            )
    }
}

struct SymbolCell: View {
    @Binding var currentIcon: String
    @State var image: String
    @State var iconColor: Color
    
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



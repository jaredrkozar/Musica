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
    @State private var selectedFilter: IconFilter? = nil {
        willSet {
            if newValue?.filterName == selectedFilter?.filterName {
                selectedFilter = nil
            } else {
                selectedFilter = newValue
            }
        }
    }
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack {
                ForEach(icons) { filter in
                    Button {
                        selectedFilter = filter
                       
                    } label: {
                        IconFilterCell(filter: filter, activeFilter: $selectedFilter, iconColor: iconColor)
                    }
                    .padding(3)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 20, alignment: .topLeading)
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
            
            Image(systemName: isFilterSelected ? "multiply.circle" : filter.filterIcon)
        }
        .foregroundColor(isFilterSelected ? .white : iconColor)
        .padding(10)
        .background(isFilterSelected ? iconColor : .clear)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(iconColor, lineWidth: 4)
        )
      
    }
}

//
//  SortfilesButton.swift
//  Musica
//
//  Created by Jared Kozar on 10/26/23.
//

import Foundation
import SwiftUI

struct SortfilesButton: View {
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        Menu {
            Picker("Sort Order", selection: $viewModel.sortDirection) {
                ForEach([SortOrder.forward, SortOrder.reverse], id: \.self) { order in
                    Text(order.name)
                }
            }
            Picker("Sort By", selection: $viewModel.sortMethod) {
                ForEach(SortMethods.allCases, id: \.self) { parameter in
                    Text(parameter.asString)
                }
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
        }
        .pickerStyle(.automatic)
    }
}

//
//  ColorPickerCdll.swift
//  Musica
//
//  Created by Jared Kozar on 10/1/23.
//

import Foundation
import SwiftUI

struct ColorPickerCell: View {
    @Binding var currentColor: CustomColors
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 40), alignment: .top)]) {
            ForEach(CustomColors.allCases, id: \.id) { color in
                Button {
                    currentColor = color
                } label: {
                    ZStack {
                        Circle()
                            .fill(color.color)
                            .accessibilityHint(Text(color.name))
                            .overlay {
                                
                                Image(systemName: "checkmark")
                                    .fontWeight(.black)
                                    .tint(color.isMatchingColor(color: currentColor) ? .white : color.color)
                                    .frame(maxWidth: .infinity)
                            }
                    }
                }
            }
        }
    }
}

//
//  TextCell.swift
//  Musica
//
//  Created by Jared Kozar on 9/30/23.
//

import SwiftUI

struct TextCell: View {

    @Binding var currentValue: String
    @State var placeholder: String
    @State var leftText: String
    
    var body: some View {
        HStack {
            Text(leftText)
            
            TextField(placeholder, text: $currentValue)
                .multilineTextAlignment(.trailing)
        }
    }
}

//
//  MusicaIcon.swift
//  Musica
//
//  Created by Jared Kozar on 10/6/23.
//

import SwiftUI

struct MusicaIcon: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 29.0)
                .fill(Color.red.gradient)
                .frame(width: 200.0, height: 200.0, alignment: .bottom)
        }
    }
}

#Preview {
    MusicaIcon()
}

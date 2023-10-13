//
//  CustomViewCell.swift
//  Musica
//
//  Created by Jared Kozar on 10/1/23.
//

import Foundation
import SwiftUI

struct CustomViewCell<Content: View>: View {
    let content: Content

    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
    }
}


//
//  LinkCell.swift
//  Musica
//
//  Created by Jared Kozar on 10/1/23.
//

import Foundation
import SwiftUI

struct LinkCell<Destination: View, Content: View>: View {
    @ViewBuilder var destination: Destination
    @ViewBuilder let content: Content

    init( @ViewBuilder _ destination: () -> Destination, @ViewBuilder _ content: () -> Content) {
        self.destination = destination()
        self.content = content()
    }
    
    public var body: some View {
        NavigationLink(destination: destination) {
            content
        }
    }
}

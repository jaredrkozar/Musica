//
//  SongInfoView.swift
//  Musica
//
//  Created by Jared Kozar on 10/27/24.
//

import SwiftUI

struct SongInfoView: View {
    var body: some View {
       Text("Coming soon")
    }
}

public extension Binding {
    /// Create a non-optional version of an optional `Binding` with a default value
    /// - Parameters:
    ///   - lhs: The original `Binding<Value?>` (binding to an optional value)
    ///   - rhs: The default value if the original `wrappedValue` is `nil`
    /// - Returns: The `Binding<Value>` (where `Value` is non-optional)
    static func ??(lhs: Binding<Optional<Value>>, rhs: Value) -> Binding<Value> {
        Binding {
            lhs.wrappedValue ?? rhs
        } set: {
            lhs.wrappedValue = $0
        }
    }
}

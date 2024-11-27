//
//  ViewModel.swift
//  Musica
//
//  Created by Jared Kozar on 10/26/23.
//

import Foundation
import Observation

@Observable class ViewModel {
//    var sortMethod: SortMethods = .title {
//        willSet {
//            FileListView(sort: newValue, searchString: searchText, order: .reverse)
//        }
//    }
//    
//    var sortDirection: SortOrder = .forward {
//        willSet {
//            FileListView(sort: sortMethod, searchString: searchText, order: newValue)
//        }
//    }
    
    var searchText = ""
    
    var error: String = ""
    var showError: Bool = false
    var showFileImportMenu: Bool = false
}

extension SortOrder {
    /// A name for the sort order in the user interface.
    var name: String {
        switch self {
        case .forward: "Ascending"
        case .reverse: "Descending"
        }
    }
}

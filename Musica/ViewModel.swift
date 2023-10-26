//
//  ViewModel.swift
//  Musica
//
//  Created by Jared Kozar on 10/26/23.
//

import Foundation
import Observation

@Observable class ViewModel {
    var sortMethod: SortMethods = .title
    
    var sortDirection: SortOrder = .forward
    
    var searchText = ""
    
    var error: String = ""
    var showError: Bool = false
    
    var showFileImportMenu: Bool = false
    
    enum Sheet: Hashable, Identifiable {
        
        case addFile(url: URL)
        case editFile(file: File)
        
          var id: Self {

              return self
          }
    }
    
    var presentedSheet: Sheet?
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

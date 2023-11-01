//
//  SelectIconView.swift
//  Musica
//
//  Created by Jared Kozar on 10/20/23.
//

import Foundation
import SwiftUI
import UIKit

struct ImagePicker: UIViewRepresentable {

    @Binding var selectedIcon: String
    
    func makeUIView(context: Context) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = layout.estimatedItemSize
          layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCell.headerIdentifier)
        
        context.coordinator.collectionView = collectionView
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: Context) {
        context.coordinator.selected = selectedIcon
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UICollectionViewDelegate {

        var collectionView: UICollectionView? {
             didSet {
                 applySnapshot()
             }
         }
        
        private lazy var dataSource = configureDataSource()
        
        var selected: String?
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        private func configureDataSource() -> UICollectionViewDiffableDataSource<SymbolSections, String> {
            let dataSource = UICollectionViewDiffableDataSource<SymbolSections, String>(collectionView: collectionView!) { (collectionView, indexPath, icon) -> ImageCollectionViewCell? in
         
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
                cell.symbolName = icon
                
                return cell
            }
            
            dataSource.supplementaryViewProvider = { (
                collectionView: UICollectionView,
                kind: String,
                indexPath: IndexPath) -> UICollectionReusableView? in
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                             withReuseIdentifier: HeaderCell.headerIdentifier,
                                                                                     for: indexPath) as! HeaderCell
                
                header.backgroundColor = .lightGray
         
                header.headerTitle = "ll,lk,lk,"
                return header
            }
            
            collectionView?.delegate = self
            return dataSource
        }
        
        enum SymbolSections: String, Hashable {
            case communication = "Communication"
            case weather = "Weather"
            case objects = "Objects"
        }
        
        func applySnapshot() {
          
            var snapshot = NSDiffableDataSourceSnapshot<SymbolSections, String>()
            snapshot.appendSections([.communication, .weather, .objects])
            snapshot.appendItems(communicationSymbols, toSection: .communication)
            snapshot.appendItems(weatherSymbols, toSection: .weather)
            snapshot.appendItems(objectSymbols, toSection: .objects)
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}

class ImageCollectionViewCell: UICollectionViewCell {
    // Create an ImageView to display the image
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var symbolName: String?
    static let identifier = "imageCell"
    
    override func layoutSubviews() {
        imageView.image = UIImage(systemName: symbolName ?? "exclamationmark.triangle")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add the imageView to the cell's content view
        contentView.addSubview(imageView)

        // Define constraints for the imageView
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HeaderCell: UICollectionReusableView {
    static let headerIdentifier = "headerCellIdentifier"
    
    var headerTitle: String
  
    private let headerLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 5, width: 50, height: 30))
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textColor = .red
        
        return label
    }()
    
    override func layoutSubviews() {
        headerLabel.text = headerTitle
    }
    
    override init(frame: CGRect) {
        self.headerTitle = "LDDL"
        super.init(frame: frame)
        
        // Add the imageView to the cell's content view
        self.addSubview(headerLabel)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

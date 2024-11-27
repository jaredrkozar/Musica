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
        collectionView.register(SectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier)
        
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
            super.init()
    
            self.applySnapshot()
        }
        
        private func configureDataSource() -> UICollectionViewDiffableDataSource<SymbolSections, String> {
            let dataSource = UICollectionViewDiffableDataSource<SymbolSections, String>(collectionView: collectionView!) { (collectionView, indexPath, icon) -> ImageCollectionViewCell? in
         
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
                cell.symbolName = icon
                
                return cell
            }
            
            dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
              // 2
              let kind = UICollectionView.elementKindSectionHeader
              // 3
              let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier,
                for: indexPath) as? SectionHeaderReusableView
              // 4
              let section = self.dataSource.snapshot()
                .sectionIdentifiers[indexPath.section]
              view?.titleLabel.text = "section.title"
              return view
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
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let item = dataSource.itemIdentifier(for: indexPath) else {
                return
            }
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

class SectionHeaderReusableView: UICollectionReusableView {
  static var reuseIdentifier: String {
    return String(describing: SectionHeaderReusableView.self)
  }

  // 2
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(
      ofSize: UIFont.preferredFont(forTextStyle: .title1).pointSize,
      weight: .bold)
    label.adjustsFontForContentSizeCategory = true
    label.textColor = .label
    label.textAlignment = .left
    label.numberOfLines = 1
    label.setContentCompressionResistancePriority(
      .defaultHigh,
      for: .horizontal)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    // 3
    backgroundColor = .systemBackground
    addSubview(titleLabel)

    if UIDevice.current.userInterfaceIdiom == .pad {
      NSLayoutConstraint.activate([
        titleLabel.leadingAnchor.constraint(
          equalTo: leadingAnchor,
          constant: 5),
        titleLabel.trailingAnchor.constraint(
          lessThanOrEqualTo: trailingAnchor,
          constant: -5)])
    } else {
      NSLayoutConstraint.activate([
        titleLabel.leadingAnchor.constraint(
          equalTo: readableContentGuide.leadingAnchor),
        titleLabel.trailingAnchor.constraint(
          lessThanOrEqualTo: readableContentGuide.trailingAnchor)
      ])
    }
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(
        equalTo: topAnchor,
        constant: 10),
      titleLabel.bottomAnchor.constraint(
        equalTo: bottomAnchor,
        constant: -10)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


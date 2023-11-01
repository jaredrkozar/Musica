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
          collectionView.delegate = context.coordinator
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.delegate = context.coordinator
        collectionView.dataSource = context.coordinator
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: Context) {
        context.coordinator.selected = selectedIcon
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
        var selected: String?
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return allSymbols[section].symbols.count
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return allSymbols.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
            
            let imageToShow = allSymbols[indexPath.section].symbols[indexPath.item]
            
            cell.symbolName = imageToShow

            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            self.parent.selectedIcon = allSymbols[indexPath.section].symbols[indexPath.item]
            collectionView.reloadData()
        }
        
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
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





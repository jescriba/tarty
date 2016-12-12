//
//  ArtworkCollectionView.swift
//  Tarty
//
//  Created by Joshua Escribano on 11/26/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import UIKit

protocol ArtworkCollectionViewDelegate {
    func shouldRefresh()
    func didSelect(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

class ArtworkCollectionView: UICollectionView {
    
    var collectionDelegate: ArtworkCollectionViewDelegate?
    var artworks = [Artwork]()
    var selectedArtworks = [Artwork]()
    var refreshOffset = 10
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        dataSource = self
        delegate = self
        
        let screenWidth = UIScreen.main.bounds.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/2, height: 4/3 * screenWidth / 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionViewLayout = layout
    }
    
    func reloadSelections() {
        for cell in visibleCells {
            let artworkCell = cell as! ArtworkCell
            let artwork = artworkCell.artwork
            
            if let artwork = artwork {
                if selectedArtworks.containsArtwork(artwork) {
                    artworkCell.isMarkedSelected = true
                } else {
                    artworkCell.isMarkedSelected = false
                }
            }
        }
    }
    
    func deselectItems() {
        selectedArtworks.removeAll()
        reloadSelections()
    }

}

extension ArtworkCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artworks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let artworkCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtworkCell", for: indexPath) as! ArtworkCell
        artworkCell.artwork = artworks[indexPath.row]
        
        if selectedArtworks.containsArtwork(artworkCell.artwork!) {
            artworkCell.isMarkedSelected = true
        } else {
            artworkCell.isMarkedSelected = false
        }
        
        if indexPath.row == artworks.count - refreshOffset {
            collectionDelegate?.shouldRefresh()
        }
        
        return artworkCell
    }
    
}

extension ArtworkCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ArtworkCell
        
        if !cell.isMarkedSelected {
            cell.isMarkedSelected = true
            selectedArtworks.append(cell.artwork!)
            collectionDelegate?.didSelect(collectionView, didSelectItemAt: indexPath)
        } else {
            cell.isMarkedSelected = false
            
            let index = selectedArtworks.index(of: cell.artwork!)
            if let index = index {
                selectedArtworks.remove(at: index)
            }
        }
    }
    
}


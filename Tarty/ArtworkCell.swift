//
//  ArtCell.swift
//  Tarty
//
//  Created by Joshua Escribano on 11/8/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import UIKit
import AFNetworking

class ArtworkCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    var isMarkedSelected = false {
        didSet {
            if isMarkedSelected {
                backgroundColor = UIColor(red:0.46, green:0.69, blue:1.00, alpha:1.0)
            } else {
                backgroundColor = UIColor.white
            }
        }
    }
    var artwork: Artwork? {
        didSet {
            guard let artwork = artwork else { return }
            
            if let url = artwork.links?.thumbnail {
                imageView.alpha = 0
                imageView.setImageWith(url)
                UIView.animate(withDuration: 0.2, animations: {
                    self.imageView.alpha = 1
                })
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 10
    }
    
}

//
//  DecoratedArtworkView.swift
//  Tarty
//
//  Created by Joshua Escribano on 11/27/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import UIKit

class DecoratedArtworksView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var imageViews: [UIImageView]!
    var artworks = [Artwork]()
    
    func reload(index: Int, withDuration: TimeInterval = 2) {
        let artwork = artworks[index]
        let imageView = imageViews[index]
        
        if let url = artwork.links?.thumbnail {
            
            UIView.animate(withDuration: 0, animations: {
                imageView.alpha = 0
            })
            
            imageView.setImageWith(url)
            
            UIView.animate(withDuration: withDuration, animations: {
                imageView.alpha = 1
            })
        }
        
    }
    
    func reload() {
        for i in 0...(imageViews.count - 1) {
            reload(index: i, withDuration: 1)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "DecoratedArtworksView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        
        contentView.frame = bounds
        addSubview(contentView)
        
        for imageView in imageViews {
            imageView.layer.cornerRadius = 10
        }
    }


}

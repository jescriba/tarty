//
//  Extensions.swift
//  Tarty
//
//  Created by Joshua Escribano on 11/27/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import Foundation

extension Array where Element:Artwork {
    
    func containsArtwork(_ artwork: Artwork) -> Bool {
        for item in self {
            if item.id == (artwork.id ?? "") {
                return true
            }
        }
        return false
    }
    
    func sample(size: Int) -> [Artwork] {
        
        var artworks = [Artwork]()
        
        if size > self.count {
            return self
        }
        
        for _ in 0...(size - 1) {
            let index = Int(arc4random_uniform(UInt32(self.count)))
            artworks.append(self[index])
        }
        
        return artworks
    }
    
    func subset(from: Int, to: Int) -> [Artwork] {
        if to < from {
            return [Artwork]()
        }
        
        if self.count == 0 {
            return [Artwork]()
        }
        
        var subset = [Artwork]()
        for i in from...to {
            if (self.count - 1) < i {
                return subset
            }
            subset.append(self[i])
        }
        
        return subset
    }
    
}

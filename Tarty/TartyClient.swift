//
//  TartyClient.swift
//  Tarty
//
//  Created by Joshua Escribano on 12/14/16.
//  Copyright © 2016 Joshua. All rights reserved.
//
// Interact with Parse backend
import Foundation
import Parse

class TartyClient: NSObject {
    
    class func addToCollection() {
        
    }
    
    class func removeFromCollection() {
        
    }
    
    class func loadCollection(offset: Int = 0, size: Int = 10, success: @escaping ([Artwork]) -> (), failure: @escaping (Error?) -> ()) {
        
        let query = PFQuery(className: Artwork.className)
        query.whereKey("user", equalTo: PFUser.current()!)
        
        query.findObjectsInBackground(block: {
            (pfObjects: [PFObject]?, error: Error?) -> () in
            if let pfObjects = pfObjects {
                var artworks = [Artwork]()
                for pfObject in pfObjects {
                    artworks.append(Artwork(pfObject: pfObject))
                }
                
                User.collection = artworks
                success(artworks)
            } else {
                
                failure(error)
            }
        })
    }
    
}

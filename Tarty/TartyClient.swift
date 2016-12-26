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

    class func addToCollection(artwork: Artwork) {
        
        artwork.pfObject?.saveEventually()
        //if let artist = artwork.artist {
        //    artist.pfObject?.saveEventually()
        //}
    }
    
    class func removeFromCollection(artwork: Artwork) {

        artwork.pfObject?.deleteEventually()
        artwork.pfObject = nil
        
        if let artist = artwork.artist {
            artist.pfObject?.deleteEventually()
            artist.pfObject = nil
        }
    }
    
    class func loadCollection(offset: Int = 0, size: Int = 10, success: @escaping ([Artwork]) -> (), failure: @escaping (Error?) -> ()) {
        
        let query = PFQuery(className: "ArtworkTest")
        query.whereKey("user", equalTo: PFUser.current()!)
        
        query.findObjectsInBackground(block: {
            (pfObjects: [PFObject]?, error: Error?) -> () in
            if let pfObjects = pfObjects {
                var artworks = [Artwork]()
                for pfObject in pfObjects {
                    artworks.append(Artwork(pfObject: pfObject))
                }
                
                Collection.artworks = artworks
                success(artworks)
            } else {
                
                failure(error)
            }
        })
    }
    
}

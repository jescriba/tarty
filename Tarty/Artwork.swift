//
//  Artwork.swift
//  Tarty
//
//  Created by Joshua Escribano on 11/8/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import UIKit

class Artwork: NSObject {
    var id: String?
    var title: String?
    var medium: String?
    var category: String?
    var date: String?
    var blurb: String?
    var imageVersions: [String]?
    var links: ArtworkLinks?
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? String
        title = dictionary["title"] as? String
        medium = dictionary["medium"] as? String
        category = dictionary["category"] as? String
        date = dictionary["date"] as? String
        blurb = dictionary["blurb"] as? String
        imageVersions = dictionary["image_versions"] as? [String]
        
        let linksDict = dictionary["_links"] as? NSDictionary
        if let dict = linksDict {
            links = ArtworkLinks(dictionary: dict)
        }
    }

}

class ArtworkLinks: NSObject {
    
    var thumbnail: URL?
    var genes: URL?
    var artists: URL?
    var similarArtworks: URL?
    
    init(dictionary: NSDictionary) {
        let thumbnailString = dictionary.value(forKeyPath: "thumbnail.href") as? String
        if let str = thumbnailString {
            thumbnail = URL(string: str)!
        }
        let genesString = dictionary.value(forKeyPath: "genes.href") as? String
        if let str = genesString {
            genes = URL(string: str)
        }
        let artistsString = dictionary.value(forKeyPath: "artists.href") as? String
        if let str = artistsString {
            artists = URL(string: str)
        }
        let similarArtworksString = dictionary.value(forKeyPath: "similar_artworks.href") as? String
        if let str = similarArtworksString {
            similarArtworks = URL(string: str)
        }
    }
    
}

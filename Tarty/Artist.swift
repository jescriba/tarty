//
//  Artist.swift
//  Tarty
//
//  Created by Joshua Escribano on 11/8/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import UIKit

class Artist: NSObject {
    var id: String?
    var name: String?
    var sortableName: String?
    var gender: String?
    var birthday: String?
    var hometown: String?
    var location: String?
    var nationality: String?
    var imageVersions: [String]?
    var links: ArtistLinks?

    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        sortableName = dictionary["sortable_name"] as? String
        gender = dictionary["gender"] as? String
        birthday = dictionary["birthday"] as? String
        hometown = dictionary["hometown"] as? String
        location = dictionary["location"] as? String
        nationality = dictionary["nationality"] as? String
        imageVersions = dictionary["image_versions"] as? [String]
        
        let linksDictionary = dictionary["_links"] as? NSDictionary
        if let dict = linksDictionary {
            links = ArtistLinks(dictionary: dict)
        }
    }

}

class ArtistLinks: NSObject {
    var thumbnail: URL?
    
    init(dictionary: NSDictionary) {
        let thumbnailString = dictionary.value(forKeyPath: "thumbnail.href") as? String
        if let str = thumbnailString {
            thumbnail = URL(string: str)!
        }
    }
    
}

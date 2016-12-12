//
//  Gene.swift
//  Tarty
//
//  Created by Joshua Escribano on 11/8/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import UIKit


class Gene: NSObject {
    var id: String?
    var name: String?
    var details: String?
    var imageVersions: [String]?
    var links: GeneLinks?
    
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        details = dictionary["description"] as? String
        imageVersions = dictionary["image_versions"] as? [String]
        
        let linksDict = dictionary["_links"] as? NSDictionary
        if let dict = linksDict {
            links = GeneLinks(dictionary: dict)
        }
    }

}

class GeneLinks: NSObject {
    var thumbnail: URL?
    
    init(dictionary: NSDictionary) {
        let thumbnailString = dictionary.value(forKeyPath: "thumbnail.href") as? String
        if let str = thumbnailString {
            thumbnail = URL(string: str)!
        }
    }
}

//
//  Artist.swift
//  Tarty
//
//  Created by Joshua Escribano on 11/8/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import UIKit
import Parse

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
    var _pfObject: PFObject?
    var pfObject: PFObject! {
        get {
            if _pfObject == nil {
                _pfObject = PFObject(className: "ArtistTest", dictionary: getDictionary())
                return _pfObject
            }
            
            return _pfObject
        } set {
            _pfObject = newValue
        }
    }
    
    init(pfObject: PFObject) {
        super.init()
        
        self.pfObject = pfObject
        id = pfObject.object(forKey: "id") as? String
        name = pfObject.object(forKey: "name") as? String
        sortableName = pfObject.object(forKey: "sortable_name") as? String
        gender = pfObject.object(forKey: "gender") as? String
        birthday = pfObject.object(forKey: "birthday") as? String
        hometown = pfObject.object(forKey: "hometown") as? String
        location = pfObject.object(forKey: "location") as? String
        nationality = pfObject.object(forKey: "nationality") as? String
        
        let linksDict = pfObject.object(forKey: "links") as? NSDictionary
        if let dict = linksDict {
            links = ArtistLinks(dictionary: dict)
        }
    }

    init(dictionary: NSDictionary) {
        super.init()
        
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
    
    func getDictionary() -> [String: Any] {
        var dict = [String:Any]()
        if id != nil {
            dict["id"] = id
        }
        if name != nil {
            dict["name"] = name
        }
        if sortableName != nil {
            dict["sortable_name"] = sortableName
        }
        if gender != nil {
            dict["gender"] = gender
        }
        if birthday != nil {
            dict["birthday"] = birthday
        }
        if hometown != nil {
            dict["hometown"] = hometown
        }
        if location != nil {
            dict["location"] = location
        }
        if nationality != nil {
            dict["nationality"] = nationality
        }
        if links != nil {
            dict["links"] = links!.dictionary
        }
        dict["user"] = PFUser.current()!
        return dict
    }

}

class ArtistLinks: NSObject {
    var dictionary: [String:Any]!
    var thumbnail: URL?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary as! [String: Any]
        
        let thumbnailString = dictionary.value(forKeyPath: "thumbnail.href") as? String
        if let str = thumbnailString {
            thumbnail = URL(string: str)!
        }
    }
    
}

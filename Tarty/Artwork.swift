//
//  Artwork.swift
//  Tarty
//
//  Created by Joshua Escribano on 11/8/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import UIKit
import Parse

class Artwork: NSObject {
    var id: String?
    var artistId: String?
    var artist: Artist?
    var title: String?
    var medium: String?
    var category: String?
    var date: String?
    var blurb: String?
    var imageVersions: [String]?
    var links: ArtworkLinks?
    var isInCollection: Bool = false
    var _pfObject: PFObject?
    var pfObject: PFObject! {
        get {
            if _pfObject == nil {
                _pfObject = PFObject(className: "ArtworkTest", dictionary: getDictionary())
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
        artistId = pfObject.object(forKey: "artist_id") as? String
        title = pfObject.object(forKey: "title") as? String
        medium = pfObject.object(forKey: "medium") as? String
        category = pfObject.object(forKey: "category") as? String
        blurb = pfObject.object(forKey: "blurb") as? String
        isInCollection = true
        
        let linksDict = pfObject.object(forKey: "links") as? NSDictionary
        if let dict = linksDict {
            links = ArtworkLinks(dictionary: dict)
        }
    }
    
    init(dictionary: NSDictionary) {
        super.init()
        
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
    
    func fetchArtist(success: ((Artist?) -> ())?, failure: ((Error?) -> ())?) {
        
        if let id = self.id {
            ArtsyClient.sharedInstance?.loadArtists(artworkId: id, success: {
                (artists: [Artist]) -> () in
                self.artist = artists.first
                success?(self.artist)
            }, failure: {
                (error: Error?) -> () in
                //
                failure?(error)
            })
        }
    }
    
    func getDictionary() -> [String: Any] {
        var dict = [String:Any]()
        if id != nil {
            dict["id"] = id
        }
        if artistId != nil {
            dict["artist_id"] = artistId
        }
        if title != nil {
            dict["title"] = title
        }
        if medium != nil {
            dict["medium"] = medium
        }
        if category != nil {
            dict["category"] = category
        }
        if date != nil {
            dict["date"] = date
        }
        if blurb != nil {
            dict["blurb"] = blurb
        }
        if links != nil {
            dict["links"] = links!.dictionary
        }
        if artist != nil {
            // TODO
        }
        dict["user"] = PFUser.current()!
        
        return dict
    }

}

class ArtworkLinks: NSObject {
    
    var dictionary: [String: Any]!
    var thumbnail: URL?
    var imageString: String?
    var genes: URL?
    var artists: URL?
    var similarArtworks: URL?
    
    init(dictionary: NSDictionary) {
        super.init()
        
        self.dictionary = dictionary as! [String : Any]
        
        let thumbnailString = dictionary.value(forKeyPath: "thumbnail.href") as? String
        if let str = thumbnailString {
            thumbnail = URL(string: str)!
        }
        imageString = dictionary.value(forKeyPath: "image.href") as? String
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
    
    func largestImageURL() -> URL? {
        guard imageString != nil else { return thumbnail }
        
        let largeImageString = imageString?.replacingOccurrences(of: "{image_version}", with: "large")
        if let imageString = largeImageString {
            return URL(string: imageString)
        }
        
        return thumbnail
    }
    
}

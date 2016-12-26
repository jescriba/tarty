//
//  ArtsyClient.swift
//  Tarty
//
//  Created by Joshua Escribano on 11/7/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import Foundation
import BDBOAuth1Manager
import Alamofire

// TODO OAuth for users who want to sign in
class ArtsyClient: BDBOAuth1SessionManager {
    private static let baseUrl = URL(string: "https://api.artsy.net/api")!
    private static let consumerKey = "2127e55bf7521665dd06"
    private static let consumerSecret = "cf0d15227358d96b2d22a07ed216be32"
    static let sharedInstance = ArtsyClient(baseURL: baseUrl, consumerKey: consumerKey, consumerSecret: consumerSecret)
    private var _xAppToken: String?
    private var xAppToken: String? {
        get {
            if let token = _xAppToken {
                return token
            } else {
                let parameters = [("client_id", ArtsyClient.consumerKey), ("client_secret", ArtsyClient.consumerSecret)]
                Alamofire.request(endPoint("/tokens/xapp_token", tuples: parameters), method: .post).responseJSON { response in
                    let dict = response.result.value as? NSDictionary
                    self._xAppToken = dict?["token"] as? String
                }
            }
            return _xAppToken
        }
    }
    
    func waitForXAppToken() {
        while xAppToken == nil {
            sleep(UInt32(0.1))
        }
    }
    
    func loadArtists(offset: Int? = nil, size: Int? = nil, artworkId: String? = nil, similarToArtistId: Int? = nil, geneId: Int? = nil, success: @escaping ([Artist]) -> (), failure: @escaping (Error?) -> ()) {
        
        var params = [(String, String)]()
        
        if let artworkId = artworkId {
            params.append(("artwork_id", artworkId))
        }
        if let offset = offset {
            params.append(("offset", String(offset)))
        }
        if let size = size {
            params.append(("size", String(size)))
        }
        if let geneId = geneId {
            params.append(("gene_id", String(geneId)))
        }
        if let similarToArtistId = similarToArtistId {
            params.append(("similar_to_artist_id", String(similarToArtistId)))
        }
        
        let endpoint = endPoint("/artists", tuples: params)
        let endpointURL = URL(string: endpoint)!
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "GET"
        request.addValue(xAppToken!, forHTTPHeaderField: "X-XAPP-Token")
        
        URLSession.shared.dataTask(with: request, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) -> () in
            if let data = data {
                let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                let embeddedDictionary = dictionary??["_embedded"] as? NSDictionary
                let artDictionaries = embeddedDictionary?["artists"] as? [NSDictionary]
                var artists = [Artist]()
                if let artDictionaries = artDictionaries {
                    for artDict in artDictionaries {
                        artists.append(Artist(dictionary: artDict))
                    }
                }
                
                success(artists)
            } else {
                print(error?.localizedDescription ?? "Error loading artworks")
            }
        }).resume()
        
    }
    
    func loadArtworks(offset: Int? = nil, size: Int? = nil, artistId: Int? = nil, showId: Int? = nil, similarToArtworkId: Int? = nil, geneId: String? = nil, success: @escaping ([Artwork]) -> (), failure: @escaping (Error?) -> ()) {
        
        var params = [(String, String)]()
        
        if let artistId = artistId {
            params.append(("artist_id", String(artistId)))
        }
        if let offset = offset {
            params.append(("offset", String(offset)))
        }
        if let size = size {
            params.append(("size", String(size)))
        }
        if let geneId = geneId {
            params.append(("gene_id", geneId))
        }
        if let similarToArtworkId = similarToArtworkId {
            params.append(("similar_to_artwork_id", String(similarToArtworkId)))
        }
        
        let endpoint = endPoint("/artworks", tuples: params)
        let endpointURL = URL(string: endpoint)!
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "GET"
        request.addValue(xAppToken!, forHTTPHeaderField: "X-XAPP-Token")
        
        URLSession.shared.dataTask(with: request, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) -> () in
            if let data = data {
                let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                let embeddedDictionary = dictionary??["_embedded"] as? NSDictionary
                let artDictionaries = embeddedDictionary?["artworks"] as? [NSDictionary]
                var artworks = [Artwork]()
                if let artDictionaries = artDictionaries {
                    for artDict in artDictionaries {
                        artworks.append(Artwork(dictionary: artDict))
                    }
                }
                
                success(artworks)
            } else {
                print(error?.localizedDescription ?? "Error loading artworks")
            }
        }).resume()
    }
    
    private func endPoint(_ relativeUrlPath: String = "", tuples: [(String, String)]) -> String {
        let parameters = urlEncode(tuples: tuples)
        let endPoint = ArtsyClient.baseUrl.absoluteString + relativeUrlPath + parameters
        
        return endPoint
    }
    
    private func urlEncode(tuples: [(String, String)]) -> String {
        var str = ""
        for (index, tuple) in tuples.enumerated() {
            if index == 0 {
                str += "?"
            } else {
                str += "&"
            }
            str += "\(tuple.0.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)=\(tuple.1.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
        }
        return str
    }
}

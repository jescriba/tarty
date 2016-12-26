//
//  CurateViewController.swift
//  Tarty
//
//  Created by Joshua Escribano on 12/9/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import UIKit

class CurateViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var delegate: ContainerViewController?
    var _artwork: Artwork?
    var artwork: Artwork? {
        get {
            return _artwork
        } set {
            _artwork = newValue
            
            if let url =  _artwork?.links?.largestImageURL() {
                imageView.setImageWith(url)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 28)!, NSForegroundColorAttributeName: UIColor(red:0.00, green:0.40, blue:1.00, alpha:1.0)]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if artwork == nil {
            let offset = Int(arc4random_uniform(10000))
            ArtsyClient.sharedInstance?.loadArtworks(offset: offset, size: 1, success: {
                (artworks: [Artwork]) -> () in
                self.artwork = artworks.first!
            }, failure: {
                (error: Error?) -> () in
                //
            })
        }
    }

}

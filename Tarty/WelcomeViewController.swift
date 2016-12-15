//
//  WelcomeViewController.swift
//  Tarty
//
//  Created by Joshua Escribano on 11/27/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var artworksView: DecoratedArtworksView!
    var artworks = [Artwork]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        artworksView.animate()
        
        DispatchQueue.global().async {
          ArtsyClient.sharedInstance?.waitForXAppToken()
        }
    }
    
    override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
}

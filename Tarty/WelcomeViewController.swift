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
            ArtsyClient.sharedInstance?.loadArtworks(size: 3 * 6, success: {
                (artworks: [Artwork]) -> () in
                self.artworks = artworks
            }, failure: {
                (error: Error?) -> () in
                //
            })
        }
    }
    
    override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tutorialVC = segue.destination as? TutorialViewController
        
        if let tutorialVC = tutorialVC {
            tutorialVC.artworks = artworks
        }
    }
}

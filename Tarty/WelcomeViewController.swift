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

        // TODO handle offline users
        // TODO Use user preferences and add infinite loading rather than
        // loading huge size up front
        let queue = DispatchQueue(label: "loadArtworks")
        queue.async {
            self.loadArtworks(offset: 0, size: 10)
        }
    }
    
    func loadArtworks(offset: Int, size: Int) {
        ArtsyClient.sharedInstance?.waitForXAppToken()
        
        ArtsyClient.sharedInstance?.loadArtworks(offset: offset, size: size, success: {
            (artworks: [Artwork]) -> () in
            
            self.artworks = artworks
            DispatchQueue.main.async {
                self.loadArt()

                let timer = Timer.init(timeInterval: 2.5, target: self, selector: #selector(self.reloadArt), userInfo: nil, repeats: true)
                RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
            }
        }, failure: {
            (error: Error?) -> () in
            //
        })
    }
    
    func reloadArt() {
        
        let selectedWork = artworks.sample(size: 1).first!
        let total = artworksView.imageViews.count
        let index = Int(arc4random_uniform(UInt32(total)))
        
        artworksView.artworks[index] = selectedWork
        artworksView.reload(index: index)
    }
    
    func loadArt() {
        let total = artworksView.imageViews.count
        let selectedWorks = artworks.sample(size: total)
        
        artworksView.artworks = selectedWorks
        artworksView.reload()
    }
    
    override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
}

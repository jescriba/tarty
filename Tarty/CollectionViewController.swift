//
//  HomeViewController.swift
//  Tarty
//
//  Created by Joshua Escribano on 11/27/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: ArtworkCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 28)!, NSForegroundColorAttributeName: UIColor(red:0.00, green:0.40, blue:1.00, alpha:1.0)]
        
        // TODO handle offline users
        // TODO Use user preferences and add infinite loading rather than 
        // loading huge size up front
        let queue = DispatchQueue(label: "loadArtworks")
        queue.async {
            self.loadArtworks(offset: 0, size: 200)
        }
    }
    
    func loadArtworks(offset: Int, size: Int) {
        ArtsyClient.sharedInstance?.waitForXAppToken()
        
        ArtsyClient.sharedInstance?.loadArtworks(offset: offset, size: size, success: {
            (artworks: [Artwork]) -> () in
            self.collectionView.artworks = artworks
            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
                self.collectionView.reloadSelections()
            }
        }, failure: {
            (error: Error?) -> () in
            //
        })
    }

}

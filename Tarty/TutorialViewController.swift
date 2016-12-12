//
//  ViewController.swift
//  Tarty
//
//  Created by Joshua Escribano on 11/7/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var progressTracker: UIProgressView!
    @IBOutlet weak var backwardArrowButton: UIButton!
    @IBOutlet weak var forwardArrowButton: UIButton!
    @IBOutlet weak var collectionView: ArtworkCollectionView!
    var page = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressTracker.progress = 0
        
        backwardArrowButton.isHidden = true
        forwardArrowButton.isHidden = true
        
        backwardArrowButton.addTarget(self, action: #selector(backClicked), for: .touchUpInside)
        forwardArrowButton.addTarget(self, action: #selector(nextClicked), for: .touchUpInside)
        
        // TODO handle offline users
        let queue = DispatchQueue(label: "loadArtworks")
        queue.async {
            self.loadArtworks(offset: 0)
        }
    }
    
    func loadArtworks(offset: Int) {
        ArtsyClient.sharedInstance?.waitForXAppToken()
        
        ArtsyClient.sharedInstance?.loadArtworks(offset: offset, size: 6, success: {
            (artworks: [Artwork]) -> () in
            self.collectionView.artworks = artworks
            DispatchQueue.main.async {
                self.forwardArrowButton.isHidden = false
                
                self.collectionView.reloadData()
                self.collectionView.reloadSelections()
            }
        }, failure: {
            (error: Error?) -> () in
            //
        })
    }
    
    func nextClicked() {
        backwardArrowButton.isHidden = false
        page += 1
        
        progressTracker.progress = Float(page) / 3.0
        
        let offset = page * 3
        loadArtworks(offset: offset)
        
        if page == 3 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ContainerViewController")
            
            present(vc, animated: true, completion: nil)
        }
    }
    
    func backClicked() {
        page -= 1
        
        progressTracker.progress = Float(page) / 3.0

        let offset = page * 3
        loadArtworks(offset: offset)
        if page == 0 {
            backwardArrowButton.isHidden = true
        }
    }
    
}

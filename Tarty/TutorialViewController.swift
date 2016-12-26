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
    var artworks = [Artwork]()
    var page = 0
    var pageCount = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressTracker.progress = 0
        
        backwardArrowButton.isHidden = true
        forwardArrowButton.isHidden = true
        
        backwardArrowButton.addTarget(self, action: #selector(backClicked), for: .touchUpInside)
        forwardArrowButton.addTarget(self, action: #selector(nextClicked), for: .touchUpInside)
        
        // TODO handle offline users
        if artworks.count == 0 {
            let queue = DispatchQueue(label: "loadArtworks")
            queue.async {
                self.loadArtworks()
            }
        } else {
            forwardArrowButton.isHidden = false
            collectionView.artworks = artworks.subset(from: 0, to: 5)
            collectionView.reloadData()
            collectionView.reloadSelections()
        }
    }
    
    func loadArtworks() {
        ArtsyClient.sharedInstance?.waitForXAppToken()
        
        ArtsyClient.sharedInstance?.loadArtworks(size: 6 * pageCount, success: {
            (artworks: [Artwork]) -> () in
            self.artworks = artworks
            self.collectionView.artworks = artworks.subset(from: 0, to: 5)
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
        
        collectionView.artworks = artworks.subset(from: 6 * page, to: 6 * page + 5)
        collectionView.reloadData()
        collectionView.reloadSelections()
        
        progressTracker.progress = Float(page) / Float(pageCount)

        if page == 3 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ContainerViewController")
            
            present(vc, animated: true, completion: nil)
        }
    }
    
    func backClicked() {
        page -= 1
        
        collectionView.artworks = artworks.subset(from: 6 * page, to: 6 * page + 5)
        collectionView.reloadData()
        collectionView.reloadSelections()
        
        progressTracker.progress = Float(page) / Float(pageCount)
        
        if page == 0 {
            backwardArrowButton.isHidden = true
        }
    }
    
}

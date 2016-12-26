//
//  ExploreViewController.swift
//  Tarty
//
//  Created by Joshua Escribano on 11/27/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {

    @IBOutlet weak var collectionView: ArtworkCollectionView!
    var blurView: UIVisualEffectView!
    var delegate: ContainerViewController?
    var artworkViewController: ArtworkViewController!
    var refreshCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionDelegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 28)!, NSForegroundColorAttributeName: UIColor(red:0.00, green:0.40, blue:1.00, alpha:1.0)]
        
        // TODO handle offline users
        // TODO Use user preferences and add infinite loading rather than
        // loading huge size up front
        let queue = DispatchQueue(label: "loadArtworks")
        queue.async {
            self.loadArtworks(offset: 0, size: 25)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        artworkViewController = storyboard.instantiateViewController(withIdentifier: "ArtworkViewController") as? ArtworkViewController
        
        let blurEffect = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.deselectItems()
    }
    
    func loadArtworks(offset: Int, size: Int) {
        ArtsyClient.sharedInstance?.waitForXAppToken()
        
        ArtsyClient.sharedInstance?.loadArtworks(offset: offset, size: size, success: {
            (artworks: [Artwork]) -> () in
            self.collectionView.artworks
                = artworks
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.reloadSelections()
            }
        }, failure: {
            (error: Error?) -> () in
            //
        })
    }
    
    func addArtworks() {
        // TODO
        let offset = refreshCount * (25 - 10)
        let size = 25
        ArtsyClient.sharedInstance?.waitForXAppToken()
        ArtsyClient.sharedInstance?.loadArtworks(offset: offset, size: size, success: {
            (artworks: [Artwork]) -> () in
            self.collectionView.artworks
                += artworks
            var indexPaths = [IndexPath]()
            for i in 0...24 {
                let indexPath = IndexPath(row: offset + i, section: 0)
                indexPaths.append(indexPath)
            }
            DispatchQueue.main.async {
                UIView.performWithoutAnimation {
                    self.collectionView.reloadSections(IndexSet(integer: 0))
                }
            }
        }, failure: {
            (error: Error?) -> () in
            //
        })
    }

}

extension ExploreViewController: ArtworkCollectionViewDelegate {
    func shouldRefresh() {
        refreshCount += 1
        addArtworks()
    }
    
    func didSelect(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let artworkCollectionView = collectionView as! ArtworkCollectionView
        let artwork = artworkCollectionView.artworks[indexPath.row]
        artworkViewController.artwork = artwork
        artworkCollectionView.deselectItems()
        
        blurView.alpha = 1
        navigationController?.view.addSubview(blurView)
        
        artworkViewController.delegate = self
        present(artworkViewController, animated: true, completion: nil)
    }
}

extension ExploreViewController: ArtworkViewControllerDelegate {
    
    func willDismiss() {
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
            self.blurView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: {
            (result: Bool?) -> () in
            self.blurView.removeFromSuperview()
        })
    }
    
}

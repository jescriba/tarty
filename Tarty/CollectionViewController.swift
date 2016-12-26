//
//  HomeViewController.swift
//  Tarty
//
//  Created by Joshua Escribano on 11/27/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: ArtworkCollectionView!
    var delegate: ContainerViewController?
    var blurView: UIVisualEffectView!
    var artworkViewController: ArtworkViewController!
    var refreshCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 28)!, NSForegroundColorAttributeName: UIColor(red:0.00, green:0.40, blue:1.00, alpha:1.0)]
        
        // TODO Load artworks in collection and infinite scroll
        collectionView.collectionDelegate = self
        loadCollection(offset: 0, size: 10)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        artworkViewController = storyboard.instantiateViewController(withIdentifier: "ArtworkViewController") as? ArtworkViewController
        
        let blurEffect = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadCollection(offset: 0, size: 10)
    }
    
    func loadCollection(offset: Int, size: Int) {
        TartyClient.loadCollection(offset: offset, size: size, success: {
            (artworks: [Artwork]) -> () in
            self.collectionView.artworks = artworks
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.reloadSelections()
            }
        }, failure: {
            (error: Error?) -> () in
            print(error?.localizedDescription ?? "Error loading collection")
        })
    }

}

extension CollectionViewController: ArtworkCollectionViewDelegate {
    func shouldRefresh() {
        // TODO
        refreshCount += 1
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

extension CollectionViewController: ArtworkViewControllerDelegate {
    
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

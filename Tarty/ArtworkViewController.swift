//
//  ArtworkViewController.swift
//  Tarty
//
//  Created by Joshua Escribano on 11/27/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import UIKit
import AFNetworking

class ArtworkViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var artistBirthDate: UILabel!
    @IBOutlet weak var artistLocation: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistBirthPlace: UILabel!
    @IBOutlet weak var artistImageView: UIImageView!
    var artwork: Artwork? {
        didSet {
            guard artwork != nil else {return}
            
            artwork?.fetchArtist(success: {
                (artist: Artist) -> () in
                self.artist = artist
            }, failure: {
                (error: Error?) -> () in
                // TODO
                print(error?.localizedDescription ?? "Error fetching artist")
            })
            
            view.layoutIfNeeded()
            
            if let url = artwork!.links?.thumbnail {
                imageView.setImageWith(url)
                UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
                    self.imageView.alpha = 1
                }, completion: nil)
            }
        }
    }
    var artist: Artist? {
        didSet {
            guard artist != nil else {return}

            view.layoutIfNeeded()
            
            DispatchQueue.main.async {
                self.artistName.text = self.artist?.name
                self.artistBirthDate.text = self.artist?.birthday
                self.artistLocation.text = self.artist?.location
                self.artistBirthPlace.text = self.artist?.hometown
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 28)!, NSForegroundColorAttributeName: UIColor(red:0.00, green:0.40, blue:1.00, alpha:1.0)]        
        
        if let url = artwork?.links?.thumbnail {
            imageView.setImageWith(url)
            UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
                self.imageView.alpha = 1
            }, completion: nil)
        }
        
        view.backgroundColor = .clear
        modalPresentationStyle = .overCurrentContext
        
        addButton.layer.cornerRadius = 20
        imageView.layer.cornerRadius = 20
        artistImageView.layer.cornerRadius = 10
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(recognizer)
        
        backgroundView.layer.cornerRadius = 20
        
        addButton.addTarget(self, action: #selector(onAddButton), for: .valueChanged)
    }
    
    func onAddButton() {
        // Toggle the state and add/remove artwork from collection
        // TODO
    }
    
    func onPan(recognizer: UIPanGestureRecognizer) {
        if recognizer.translation(in: view).y > 0 {
            dismiss(animated: true, completion: nil)
        }
    }

}

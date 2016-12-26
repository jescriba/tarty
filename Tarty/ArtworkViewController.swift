//
//  ArtworkViewController.swift
//  Tarty
//
//  Created by Joshua Escribano on 11/27/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import UIKit
import AFNetworking

protocol ArtworkViewControllerDelegate {
    func willDismiss()
}

class ArtworkViewController: UIViewController {
    
    @IBOutlet weak var backgroundViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artworkTitle: UILabel!
    var screenHeight: CGFloat!
    var originalBackgroundTopConstraint: CGFloat!
    var delegate: ArtworkViewControllerDelegate?
    var artwork: Artwork? {
        didSet {
            guard artwork != nil else {return}

            view.layoutIfNeeded()
            
            if artwork?.artist == nil {
                artwork?.fetchArtist(success: {
                    (artist: Artist?) -> () in
                    self.artist = artist
                }, failure: {
                    (error: Error?) -> () in
                    // TODO
                    print(error?.localizedDescription ?? "Error fetching artist")
                })
            } else {
                artist = artwork?.artist
            }

            DispatchQueue.main.async {
                self.artworkTitle.text = self.artwork?.title
                self.imageView.alpha = 0
                if let url = self.artwork!.links?.largestImageURL() {
                    self.imageView.setImageWith(url)
                    UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
                        self.imageView.alpha = 1
                        self.view.layoutIfNeeded()
                    }, completion: nil)
                }
            }
        }
    }
    var artist: Artist? {
        didSet {
            guard artist != nil else {return}

            view.layoutIfNeeded()
            
            DispatchQueue.main.async {
                self.artistName.text = self.artist?.name ?? ""
                self.artistImageView.alpha = 0
                if let url = self.artist!.links?.thumbnail {
                    self.artistImageView.setImageWith(url)
                    UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
                        self.artistImageView.alpha = 1
                        self.view.layoutIfNeeded()
                    }, completion: nil)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 28)!, NSForegroundColorAttributeName: UIColor(red:0.00, green:0.40, blue:1.00, alpha:1.0)]
        
        view.backgroundColor = .clear
        modalPresentationStyle = .overCurrentContext
        
        addButton.layer.cornerRadius = 20
        imageView.layer.cornerRadius = 20
        artistImageView.layer.cornerRadius = 10
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(recognizer)
        
        backgroundView.layer.cornerRadius = 20
        
        addButton.addTarget(self, action: #selector(onAddButton), for: .touchUpInside)
        
        artistName.adjustsFontSizeToFitWidth = true
        artworkTitle.adjustsFontSizeToFitWidth = true
        
        originalBackgroundTopConstraint = backgroundViewTopConstraint.constant
        
        screenHeight = UIApplication.shared.keyWindow?.screen.bounds.height ?? 300
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        artistName.text = "-"
        artworkTitle.text = "-"
        artistImageView.alpha = 0
        imageView.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backgroundViewTopConstraint.constant = originalBackgroundTopConstraint
        
        if artwork!.isInCollection {
            addButton.setTitle("x", for: .normal)
        } else {
            addButton.setTitle("+", for: .normal)
        }
    }
    
    func onAddButton() {
        // TODO
        guard artwork != nil else {return}
        
        if artwork!.isInCollection {
            artwork?.isInCollection = false
            TartyClient.removeFromCollection(artwork: artwork!)
            addButton.setTitle("+", for: .normal)
        } else {
            artwork?.isInCollection = true
            TartyClient.addToCollection(artwork: artwork!)
            addButton.setTitle("x", for: .normal)
        }

    }
    
    func onPan(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.location(in: view).y
        let velocity = recognizer.velocity(in: view).y
        let state = recognizer.state
        
        if state == .changed {
            let newConstraint = originalBackgroundTopConstraint + translation
            if newConstraint >= 0 && newConstraint < 2 * screenHeight / 3.0 {
                backgroundViewTopConstraint.constant = newConstraint
            }
            if (newConstraint >= 0 && newConstraint > 2 * screenHeight / 3.0) {
                closeBackgroundView()
            }
        } else if state == .ended {
            if velocity > 0 {
                closeBackgroundView()
            } else {
                openBackgroundView()
            }
        }
    }
    
    func closeBackgroundView() {
        delegate?.willDismiss()
        dismiss(animated: false, completion: nil)
    }
    
    func openBackgroundView() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            self.backgroundViewTopConstraint.constant = self.originalBackgroundTopConstraint
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

}

//
//  DecoratedArtworkView.swift
//  Tarty
//
//  Created by Joshua Escribano on 11/27/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import UIKit

class DecoratedArtworksView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var imageViews: [UIImageView]!
    var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "DecoratedArtworksView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        
        contentView.frame = bounds
        addSubview(contentView)
        
        for (i, imageView) in imageViews.enumerated() {
            imageView.layer.cornerRadius = 10
            let randInt = Int(arc4random_uniform(3)) + 3 * i + 1
            imageView.image = UIImage(named: "art\(randInt)")
        }
    }
    
    func animate() {
        let randImageInt = Int(arc4random_uniform(4))
        let randInt = Int(arc4random_uniform(3)) + 3 * randImageInt + 1
        
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
            self.imageViews[randImageInt].alpha = 0
        }, completion: nil)
        
        imageViews[randImageInt].image = UIImage(named: "art\(randInt)")
        
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
            self.imageViews[randImageInt].alpha = 1
        }, completion: nil)
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
        }
    }


}

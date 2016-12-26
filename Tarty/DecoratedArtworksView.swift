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
            imageView.tag = randInt
            imageView.image = UIImage(named: "art\(randInt)")
        }
    }
    
    func animate() {
        let randImageInt = Int(arc4random_uniform(4))
        let randInt = newRandomImageIndex(previous: imageViews[randImageInt].tag, imageIndex: randImageInt)
        
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
            self.imageViews[randImageInt].alpha = 0
        }, completion: nil)
        
        imageViews[randImageInt].tag = randInt
        imageViews[randImageInt].image = UIImage(named: "art\(randInt)")
        
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
            self.imageViews[randImageInt].alpha = 1
        }, completion: nil)
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
        }
    }
    
    func newRandomImageIndex(previous: Int, imageIndex: Int) -> Int {
        let rand = Int(arc4random_uniform(3)) + 3 * imageIndex + 1
        
        if previous == rand {
            return newRandomImageIndex(previous: previous, imageIndex: imageIndex)
        }
        
        return rand
    }


}

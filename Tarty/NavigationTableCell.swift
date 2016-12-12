//
//  NavigationTableCell.swift
//  Tarty
//
//  Created by Joshua Escribano on 12/11/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import UIKit

class NavigationTableCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor(red:0.91, green:0.84, blue:1.00, alpha:1.0)
        selectedBackgroundView = bgView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

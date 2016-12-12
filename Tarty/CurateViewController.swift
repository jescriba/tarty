//
//  CurateViewController.swift
//  Tarty
//
//  Created by Joshua Escribano on 12/9/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import UIKit

class CurateViewController: UIViewController {
    var delegate: ContainerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 28)!, NSForegroundColorAttributeName: UIColor(red:0.00, green:0.40, blue:1.00, alpha:1.0)]
    }

}

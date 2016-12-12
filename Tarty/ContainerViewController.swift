//
//  ContainerViewController.swift
//  Tarty
//
//  Created by Joshua Escribano on 11/27/16.
//  Copyright © 2016 Joshua. All rights reserved.
//

import UIKit

enum Page: Int {
    case collection, explore, curate
    
    func simpleDescription() -> String {
        switch self {
        case .collection:
            return "Collection"
        case .explore:
            return "Explore"
        case .curate:
            return "Curate"
        }
    }
}

class ContainerViewController: UIViewController {

    @IBOutlet weak var navigationTableView: UITableView!
    @IBOutlet weak var contentViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    var leftMargin: CGFloat = 0
    var _page: Page = Page.collection
    var page: Page! {
        get {
            return _page
        } set {
            let vc = viewControllers[newValue.rawValue]
            let childVC = childViewControllers.first
            if let child = childVC {
                child.willMove(toParentViewController: nil)
                child.view.removeFromSuperview()
                child.removeFromParentViewController()
            }
            
            addChildViewController(vc)
            contentView.addSubview(vc.view)
            vc.didMove(toParentViewController: self)
            
            _page = newValue
            
            closeNavigationPanel()
            
            view.layoutIfNeeded()
        }
    }
    var viewControllers = [UIViewController]()
    let pages = [Page.collection, Page.explore, Page.curate]
    private let maxLeadingConstant: CGFloat = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let collectionNavigationVC = storyboard.instantiateViewController(withIdentifier: "CollectionNavigationController") as! UINavigationController
        let exploreNavigationVC = storyboard.instantiateViewController(withIdentifier: "ExploreNavigationController") as! UINavigationController
        let curateNavigationVC = storyboard.instantiateViewController(withIdentifier: "CurateNavigationController") as! UINavigationController

        viewControllers.append(collectionNavigationVC)
        viewControllers.append(exploreNavigationVC)
        viewControllers.append(curateNavigationVC)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onContentPan))
        contentView.addGestureRecognizer(panRecognizer)
        
        navigationTableView.delegate = self
        navigationTableView.dataSource = self
        navigationTableView.tableFooterView = UIView(frame: .zero)
        navigationTableView.separatorStyle = .none
        navigationTableView.rowHeight = 100
        
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOpacity = 1
        
        page = Page.collection
    }
    
    func onContentPan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.location(in: view).x
        let velocity = recognizer.velocity(in: view).x
        let state = recognizer.state
        
        if state == .changed {
            let newConstraint = leftMargin + translation
            if newConstraint >= 0 && newConstraint < maxLeadingConstant + 20 {
                contentViewLeadingConstraint.constant = newConstraint
            }
        } else if state == .ended {
            if velocity > 0 {
                openNavigationPanel()
            } else {
                closeNavigationPanel()
            }
        }
    }
    
    func openNavigationPanel() {
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            self.contentViewLeadingConstraint.constant = self.maxLeadingConstant
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func closeNavigationPanel() {
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            self.contentViewLeadingConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

}

extension ContainerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        page = pages[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ContainerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NavigationTableCell", for: indexPath) as! NavigationTableCell
        cell.title.text = pages[indexPath.row].simpleDescription()
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }
    
}

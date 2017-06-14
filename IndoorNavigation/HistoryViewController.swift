//
//  HistoryViewController.swift
//  IndoorNavigation
//
//  Created by jeff on 13/06/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }
    
    @objc
    private func handleBack() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromLeft
        view.window?.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(HomeViewController(), animated: true)
    }

}

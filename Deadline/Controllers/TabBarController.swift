//
//  TabBarController.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/12/16.
//

import UIKit

protocol TabBarControllerDelegate {
    func tapTabBarItem(previousVC: String, tag: Int)
}

class TabBarController: UITabBarController {
    
    var tabBarDelegate: TabBarControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
}

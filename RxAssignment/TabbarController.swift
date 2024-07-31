//
//  TabbarController.swift
//  RxAssignment
//
//  Created by ilim on 2024-08-01.
//

import UIKit

enum TabImage: String, CaseIterable {
    case tab1 = "plus"
    case tab2 = "checklist"
    case tab3 = "list.bullet"
}

class TabbarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .gray
        
        var tabs =
        [
         SimpleAddingNumbers(),
         SimpleValidation(),
         SimpleTableView()
        ]
        
        for i in 0...2 {
            tabs[i] = UINavigationController(rootViewController: tabs[i])
            tabs[i].tabBarItem = UITabBarItem(title: nil,
                                              image: UIImage(systemName: TabImage.allCases[i].rawValue),
                                              tag: i)
        }
        
        setViewControllers(tabs, animated: true)
    }
}

//
//  MainTabBarControllerViewController.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/20/25.
//

import UIKit

/// Wegg 탭바컨트롤러
class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()

    }
    
    /// 탭바 설정 함수
    private func setupTabBar() {
        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Home"), tag: 1)
        
        let browseVC = UINavigationController(rootViewController: HomeViewController())
        browseVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Search"), tag: 2)
        
        let bookVC = UINavigationController(rootViewController: HomeViewController())
        bookVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Book"), tag: 3)
        
        let mapVC = UINavigationController(rootViewController: HomeViewController())
        mapVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Map"), tag: 4)
        
        let myVC = UINavigationController(rootViewController: HomeViewController())
        myVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "My"), tag: 5)
        
        self.viewControllers = [homeVC, browseVC, bookVC, mapVC, myVC]
    }
    
}


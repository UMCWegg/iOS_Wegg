//
//  MainTabBarControllerViewController.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/20/25.
//

import UIKit

/// Wegg 탭바컨트롤러
class MainTabBarControllerViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()

    }
    
    /// 탭바 설정 함수
    private func setupTabBar() {
        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarITem(title: "", image: UIImage(named: "Home"), tag: 1)
        
        let BrowseVC = UINavigationController(rootViewController: HomeViewController())
        BrowseVC.tabBarItem = UITabBarITem(title: "", image: UIImage(named: "Search"), tag: 2)
        
        let BookVC = UINavigationController(rootViewController: HomeViewController())
        BookVC.tabBarItem = UITabBarITem(title: "", image: UIImage(named: "Book"), tag: 3)
        
        let MapVC = UINavigationController(rootViewController: HomeViewController())
        MapVC.tabBarItem = UITabBarITem(title: "", image: UIImage(named: "Map"), tag: 4)
        
        let MyVC = UINavigationController(rootViewController: HomeViewController())
        MyVC.tabBarItem = UITabBarITem(title: "", image: UIImage(named: "My"), tag: 5)
    }

}

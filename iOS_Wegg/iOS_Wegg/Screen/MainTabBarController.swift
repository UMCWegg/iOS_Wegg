//
//  MainTabBarControllerViewController.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/20/25.
//

import UIKit

/// Wegg 탭바컨트롤러
class MainTabBarController: UITabBarController {
    // 의존성 주입을 위한 지도 관리 매니저 인스턴스 생성
    private let mapManager = NaverMapManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        appearance()
    }
    
    /// 탭바 설정 함수
    private func setupTabBar() {
        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Home"), tag: 1)
        
        let browseVC = UINavigationController(rootViewController: BrowseViewController())
        browseVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Search"), tag: 2)
        
        let mapVC = UINavigationController(
            rootViewController: MapViewController(mapManager: mapManager)
        )
        mapVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Map"), tag: 3)
        
        let timeVC = UINavigationController(rootViewController: TimeViewController())
        timeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Time"), tag: 4)
        
        let myVC = UINavigationController(rootViewController: MyPageViewController())
        myVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "My"), tag: 5)
        
        self.viewControllers = [homeVC, browseVC, mapVC, timeVC, myVC]
    }
    
    /// 클릭 시, 디자이너 지정 컬러로 칠해지도록 하는 함수
    private func appearance() {
        // UITabBarAppearance 설정
        let barAppearance = UITabBarAppearance()
        
        // BluePrimary 색상 가져오기
        guard let bluePrimary = UIColor(named: "BluePrimary") else {
            print("Error: 컬러가 존재하지 않습니다.")
            return
        }
        
        // 선택된 아이템의 Appearance 설정
        barAppearance.stackedLayoutAppearance.selected.iconColor = bluePrimary
        // 선택된 아이템의 텍스트 색상 적용
        barAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: bluePrimary
        ]
        // 알림이나 뱃지 색상 적용
        barAppearance.stackedLayoutAppearance.selected.badgeBackgroundColor = bluePrimary
        // UITabBar에 적용하기
        self.tabBar.standardAppearance = barAppearance
        self.tabBar.backgroundColor = .clear
    }
}

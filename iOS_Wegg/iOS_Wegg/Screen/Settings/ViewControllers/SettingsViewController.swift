//
//  SettingsViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.18.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: - Properties
    
    private let settingsView = SettingsView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = settingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActions()
        
        view.backgroundColor = .yellowBg
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupActions() {
        settingsView.profileButton.addTarget(
            self,
            action: #selector(profileButtonTapped),
            for: .touchUpInside
        )
        
        settingsView.alarmSettingButton.addTarget(
            self,
            action: #selector(alarmSettingButtonTapped),
            for: .touchUpInside
        )
        
        settingsView.featureSettingButton.addTarget(
            self,
            action: #selector(featureSettingButtonTapped),
            for: .touchUpInside
        )
        
        settingsView.privacySettingButton.addTarget(
            self,
            action: #selector(privacySettingButtonTapped),
            for: .touchUpInside
        )
        
        settingsView.pointPurchaseButton.addTarget(
            self,
            action: #selector(pointPurchaseButtonTapped),
            for: .touchUpInside
        )
        
        settingsView.refreshButton.addTarget(
            self,
            action: #selector(refreshButtonTapped),
            for: .touchUpInside
        )
    }
    
    // MARK: - Actions
    
    @objc private func profileButtonTapped() {
       let profileEditVC = ProfileEditViewController()
       navigationController?.pushViewController(profileEditVC, animated: true)
    }
    
    @objc private func alarmSettingButtonTapped() {
       // let alarmSettingVC = AlarmSettingViewController()
       // navigationController?.pushViewController(alarmSettingVC, animated: true)
    }
    
    @objc private func featureSettingButtonTapped() {
       // let featureSettingVC = FeatureSettingViewController()
       // navigationController?.pushViewController(featureSettingVC, animated: true)
    }
    
    @objc private func privacySettingButtonTapped() {
       // let privacySettingVC = PrivacySettingViewController()
       // navigationController?.pushViewController(privacySettingVC, animated: true)
    }
    
    @objc private func pointPurchaseButtonTapped() {
      // let pointPurchaseVC = PointPurchaseViewController()
      // navigationController?.pushViewController(pointPurchaseVC, animated: true)
    }
    
    @objc private func refreshButtonTapped() {
        // 친구 추천 목록 새로고침 API 호출
        settingsView.refreshButton.addTarget(
            self,
            action: #selector(refreshContactList),
            for: .touchUpInside
        )
    }
    
    @objc private func refreshContactList() {
        // 실제 친구 목록 새로고침 로직 구현
    }

}

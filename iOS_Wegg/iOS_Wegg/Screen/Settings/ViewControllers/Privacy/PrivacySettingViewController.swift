//
//  PrivacySettingViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

import UIKit

class PrivacySettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let privacySettingView = PrivacySettingView()
    private let settingsStorage = SettingsStorage.shared
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = privacySettingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActions()
        loadSettings()
        
        view.backgroundColor = .yellowBg
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = "계정 공개 범위"
        
        let backButton = SettingBackButton()
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupActions() {
        privacySettingView.allCell.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(allCellTapped))
        )
        
        privacySettingView.mutualCell.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(mutualCellTapped))
        )
    }
    
    private func loadSettings() {
        // 로컬 저장소에서 설정 불러오기
        let visibility = settingsStorage.getProfileVisibility()
        
        // UI 업데이트
        updateUI(visibility: visibility)
    }
    
    private func updateUI(visibility: ProfileVisibility) {
        // 체크 초기화
        privacySettingView.allCell.accessoryType = .none
        privacySettingView.mutualCell.accessoryType = .none
        
        // 현재 설정된 공개 범위에 체크 표시
        switch visibility {
        case .all:
            privacySettingView.allCell.accessoryType = .checkmark
        case .mutual:
            privacySettingView.mutualCell.accessoryType = .checkmark
        }
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func allCellTapped() {
        settingsStorage.saveProfileVisibility(.all)
        updateUI(visibility: .all)
        syncSettingsWithServer()
    }
    
    @objc private func mutualCellTapped() {
        settingsStorage.saveProfileVisibility(.mutual)
        updateUI(visibility: .mutual)
        syncSettingsWithServer()
    }
    
    private func syncSettingsWithServer() {
        // 서버에 설정 업데이트 요청
        Task {
            do {
                let settings = settingsStorage.createSettingsUpdateRequest()
                let response = try await SettingsService.shared.updateSettings(settings: settings)
                if response.isSuccess {
                    print("✅ 계정 공개 범위 업데이트 성공")
                } else {
                    print("❌ 계정 공개 범위 업데이트 실패: \(response.message)")
                }
            } catch {
                print("❌ 계정 공개 범위 업데이트 오류: \(error)")
            }
        }
    }
}

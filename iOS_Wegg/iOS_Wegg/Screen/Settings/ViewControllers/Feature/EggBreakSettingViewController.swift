//
//  EggBreakSettingViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

import UIKit

class EggBreakSettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let eggBreakSettingView = EggBreakSettingView()
    private let settingsStorage = SettingsStorage.shared
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = eggBreakSettingView
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
        navigationItem.title = "알 깨기 기능"
        
        let backButton = SettingBackButton()
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupActions() {
        eggBreakSettingView.onCell.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onCellTapped))
        )
        
        eggBreakSettingView.offCell.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(offCellTapped))
        )
    }
    
    private func loadSettings() {
        // 로컬 저장소에서 설정 불러오기
        let isEnabled = settingsStorage.getFeatureEnabled(for: "eggBreak") ?? true
        
        // UI 업데이트
        updateUI(isEnabled: isEnabled)
    }
    
    private func updateUI(isEnabled: Bool) {
        // 체크 초기화
        eggBreakSettingView.onCell.accessoryType = .none
        eggBreakSettingView.offCell.accessoryType = .none
        
        // 현재 설정에 체크 표시
        eggBreakSettingView.onCell.accessoryType = isEnabled ? .checkmark : .none
        eggBreakSettingView.offCell.accessoryType = !isEnabled ? .checkmark : .none
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func onCellTapped() {
        settingsStorage.saveFeatureEnabled(true, for: "eggBreak")
        updateUI(isEnabled: true)
        syncSettingsWithServer()
    }
    
    @objc private func offCellTapped() {
        settingsStorage.saveFeatureEnabled(false, for: "eggBreak")
        updateUI(isEnabled: false)
        syncSettingsWithServer()
    }
    
    private func syncSettingsWithServer() {
        // 서버에 설정 업데이트 요청
        Task {
            do {
                let settings = settingsStorage.createSettingsUpdateRequest()
                let response = try await SettingsService.shared.updateSettings(settings: settings)
                if response.isSuccess {
                    print("✅ 알 깨기 기능 설정 업데이트 성공")
                } else {
                    print("❌ 알 깨기 기능 설정 업데이트 실패: \(response.message)")
                }
            } catch {
                print("❌ 알 깨기 기능 설정 업데이트 오류: \(error)")
            }
        }
    }
}

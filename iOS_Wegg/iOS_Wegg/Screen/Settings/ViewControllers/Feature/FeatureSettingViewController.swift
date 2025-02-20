//
//  FeatureSettingViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

import UIKit

class FeatureSettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let featureSettingView = FeatureSettingView()
    private let settingsStorage = SettingsStorage.shared
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = featureSettingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActions()
        loadSettings()
        
        view.backgroundColor = .yellowBg
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSettings() // 설정 변경사항 반영
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = "기능 설정"
        
        let backButton = SettingBackButton()
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupActions() {
        featureSettingView.locationToggle.toggleHandler = { [weak self] isOn in
            self?.updateLocationSetting(isOn: isOn)
        }
        
        featureSettingView.randomToggle.toggleHandler = { [weak self] isOn in
            self?.updateRandomSetting(isOn: isOn)
        }
        
        featureSettingView.eggBreakButton.addTarget(
            self,
            action: #selector(eggBreakButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func loadSettings() {
        // 기능 활성화 상태 불러오기
        let locationEnabled = settingsStorage.getFeatureEnabled(for: "location") ?? true
        let randomEnabled = settingsStorage.getFeatureEnabled(for: "random") ?? true
        let eggBreakEnabled = settingsStorage.getFeatureEnabled(for: "eggBreak") ?? true
        
        // UI 업데이트
        featureSettingView.locationToggle.configure(with: "장소 인증 기능", isOn: locationEnabled)
        featureSettingView.randomToggle.configure(with: "랜덤 인증 기능", isOn: randomEnabled)
        
        // 알 깨기 상태 표시
        let eggBreakStatus = eggBreakEnabled ? "끔" : "꺼짐"
        featureSettingView.eggBreakButton.setTitle("알 깨기 기능      \(eggBreakStatus)", for: .normal)
        featureSettingView.eggBreakButton
            .setImage(UIImage(systemName: "chevron.right"), for: .normal)
        
        // 경고 메시지 표시 (기능을 꺼둘 경우)
        updateWarningMessage(locationEnabled, randomEnabled)
    }
    
    private func updateWarningMessage(_ locationEnabled: Bool, _ randomEnabled: Bool) {
        if !locationEnabled {
            featureSettingView.warningLabel.text = "장소 인증 기능을 끄면 다른 친구들의 게시물을 볼 수 없어요"
            featureSettingView.warningLabel.isHidden = false
        } else if !randomEnabled {
            featureSettingView.warningLabel.text = "랜덤 인증 기능을 끄면 다른 친구들의 게시물을 볼 수 없어요"
            featureSettingView.warningLabel.isHidden = false
        } else {
            featureSettingView.warningLabel.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func eggBreakButtonTapped() {
        let eggBreakVC = EggBreakSettingViewController()
        navigationController?.pushViewController(eggBreakVC, animated: true)
    }
    
    private func updateLocationSetting(isOn: Bool) {
        settingsStorage.saveFeatureEnabled(isOn, for: "location")
        let randomEnabled = settingsStorage.getFeatureEnabled(for: "random") ?? true
        updateWarningMessage(isOn, randomEnabled)
        syncSettingsWithServer()
    }
    
    private func updateRandomSetting(isOn: Bool) {
        settingsStorage.saveFeatureEnabled(isOn, for: "random")
        let locationEnabled = settingsStorage.getFeatureEnabled(for: "location") ?? true
        updateWarningMessage(locationEnabled, isOn)
        syncSettingsWithServer()
    }
    
    private func syncSettingsWithServer() {
        // 서버에 설정 업데이트 요청
        Task {
            do {
                let settings = settingsStorage.createSettingsUpdateRequest()
                let response = try await SettingsService.shared.updateSettings(settings: settings)
                if response.isSuccess {
                    print("✅ 기능 설정 업데이트 성공")
                } else {
                    print("❌ 기능 설정 업데이트 실패: \(response.message)")
                }
            } catch {
                print("❌ 기능 설정 업데이트 오류: \(error)")
            }
        }
    }
}

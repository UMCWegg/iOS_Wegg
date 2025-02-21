//
//  NotificationSettingViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

import UIKit

class NotificationSettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let notificationSettingView = NotificationSettingView()
    private let settingsStorage = SettingsStorage.shared
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = notificationSettingView
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
        // 설정이 변경됐을 수 있으므로 다시 로드
        loadSettings()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = "알림 설정"
        
        let backButton = SettingBackButton()
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupActions() {
        notificationSettingView.friendPostToggle.toggleHandler = { [weak self] isOn in
            self?.updateFriendPostNotification(isOn: isOn)
        }
        
        notificationSettingView.commentToggle.toggleHandler = { [weak self] isOn in
            self?.updateCommentNotification(isOn: isOn)
        }
        
        notificationSettingView.locationNotificationCell.addTarget(
            self,
            action: #selector(locationNotificationTapped),
            for: .touchUpInside
        )
        
        notificationSettingView.randomNotificationCell.addTarget(
            self,
            action: #selector(randomNotificationTapped),
            for: .touchUpInside
        )
        
        notificationSettingView.eggBreakNotificationCell.addTarget(
            self,
            action: #selector(eggBreakNotificationTapped),
            for: .touchUpInside
        )
    }
    
    private func loadSettings() {
        // 로컬 저장소에서 설정 불러오기
        let isFriendPostEnabled = settingsStorage.getNotificationEnabled(for: "friendPost") ?? true
        let isCommentEnabled = settingsStorage.getNotificationEnabled(for: "comment") ?? true
        
        // 장소, 랜덤, 알 깨기 알림 설정 불러오기
        let locationSetting = settingsStorage.getNotificationSetting(for: "location") ??
            NotificationSetting(type: .sound, frequency: .single, isEnabled: true)
        
        let randomSetting = settingsStorage.getNotificationSetting(for: "random") ??
            NotificationSetting(type: .sound, frequency: .single, isEnabled: true)
        
        let eggBreakSetting = settingsStorage.getNotificationSetting(for: "eggBreak") ??
            NotificationSetting(type: .sound, frequency: nil, isEnabled: true)
        
        // UI 업데이트 - SettingToggleCell의 경우 configure 메서드를 사용하는 대신 직접 속성 설정
        notificationSettingView.friendPostToggle.titleLabel.text = "친구들 포스트 알림"
        notificationSettingView.friendPostToggle.toggleSwitch.isOn = isFriendPostEnabled
        
        notificationSettingView.commentToggle.titleLabel.text = "댓글 알림"
        notificationSettingView.commentToggle.toggleSwitch.isOn = isCommentEnabled
        
        // SettingDisclosureCell의 경우 직접 속성 설정
        notificationSettingView.locationNotificationCell.titleLabel.text = "장소 인증 알림"
        notificationSettingView.locationNotificationCell.detailLabel.text =
            locationSetting.isEnabled ? locationSetting.displayText : "꺼짐"
        
        notificationSettingView.randomNotificationCell.titleLabel.text = "랜덤 인증 알림"
        notificationSettingView.randomNotificationCell.detailLabel.text =
            randomSetting.isEnabled ? randomSetting.displayText : "꺼짐"
        
        notificationSettingView.eggBreakNotificationCell.titleLabel.text = "알 깨기 알림"
        notificationSettingView.eggBreakNotificationCell.detailLabel.text =
            eggBreakSetting.isEnabled ? eggBreakSetting.type.displayName : "꺼짐"
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func locationNotificationTapped() {
        let detailVC = NotificationDetailViewController(type: .location)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc private func randomNotificationTapped() {
        let detailVC = NotificationDetailViewController(type: .random)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc private func eggBreakNotificationTapped() {
        let detailVC = NotificationDetailViewController(type: .eggBreak)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func updateFriendPostNotification(isOn: Bool) {
        settingsStorage.saveNotificationEnabled(isOn, for: "friendPost")
        syncSettingsWithServer()
    }
    
    private func updateCommentNotification(isOn: Bool) {
        settingsStorage.saveNotificationEnabled(isOn, for: "comment")
        syncSettingsWithServer()
    }
    
    private func syncSettingsWithServer() {
        // 서버에 설정 업데이트 요청
        Task {
            do {
                let settings = collectCurrentSettings()
                let response = try await SettingsService.shared.updateSettings(settings: settings)
                if response.isSuccess {
                    print("✅ 알림 설정 업데이트 성공")
                } else {
                    print("❌ 알림 설정 업데이트 실패: \(response.message ?? "")")
                }
            } catch {
                print("❌ 알림 설정 업데이트 오류: \(error)")
            }
        }
    }
    
    private func collectCurrentSettings() -> SettingsUpdateRequest {
        // 현재 모든 설정을 모아서 요청 객체 생성
        return SettingsUpdateRequest(
            postAlarm: settingsStorage.getNotificationEnabled(for: "friendPost") ?? true,
            commentAlarm: settingsStorage.getNotificationEnabled(for: "comment") ?? true,
            placeAlarm: settingsStorage.getAlarmSettingString(for: "location"),
            randomAlarm: settingsStorage.getAlarmSettingString(for: "random"),
            eggAlarm: settingsStorage.getAlarmSettingString(for: "eggBreak"),
            marketingAgree: settingsStorage.getUserMarketingAgree() ?? false,
            placeCheck: settingsStorage.getFeatureEnabled(for: "location") ?? true,
            randomCheck: settingsStorage.getFeatureEnabled(for: "random") ?? true,
            breakAllow: settingsStorage.getFeatureEnabled(for: "eggBreak") ?? true,
            accountVisibility: settingsStorage.getProfileVisibility().rawValue
        )
    }
}

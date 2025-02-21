//
//  NotificationDetailViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

import UIKit

enum NotificationDetailType {
    case location
    case random
    case eggBreak
    
    var title: String {
        switch self {
        case .location: return "장소 인증 알림"
        case .random: return "랜덤 인증 알림"
        case .eggBreak: return "알 깨기 알림"
        }
    }
    
    var key: String {
        switch self {
        case .location: return "location"
        case .random: return "random"
        case .eggBreak: return "eggBreak"
        }
    }
    
    var showsFrequency: Bool {
        switch self {
        case .location, .random: return true
        case .eggBreak: return false
        }
    }
}

class NotificationDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let detailView = NotificationDetailView()
    private let notificationType: NotificationDetailType
    private let settingsStorage = SettingsStorage.shared
    
    private var currentSetting: NotificationSetting?
    
    // MARK: - Init
    
    init(type: NotificationDetailType) {
        self.notificationType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        loadCurrentSetting()
        
        view.backgroundColor = .yellowBg
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = notificationType.title
        
        let backButton = SettingBackButton()
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupUI() {
        detailView.modeLabel.text = "모드"
        
        // 알림 타입 버튼 설정 - configure 메서드 대신 직접 textLabel에 접근
        detailView.silentCell.textLabel?.text = "무음"
        detailView.vibrateCell.textLabel?.text = "진동"
        detailView.soundCell.textLabel?.text = "소리"
        detailView.bothCell.textLabel?.text = "진동 + 소리"
        
        // 알 깨기는 주파수 설정 표시하지 않음
        detailView.frequencyLabel.isHidden = !notificationType.showsFrequency
        detailView.singleCell.isHidden = !notificationType.showsFrequency
        detailView.continuousCell.isHidden = !notificationType.showsFrequency
        
        // 셀 탭 이벤트 설정
        detailView.silentCell.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(silentCellTapped))
        )
        detailView.vibrateCell.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(vibrateCellTapped))
        )
        detailView.soundCell.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(soundCellTapped))
        )
        detailView.bothCell.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(bothCellTapped))
        )
        
        detailView.singleCell.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(singleCellTapped))
        )
        detailView.continuousCell.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(continuousCellTapped))
        )
        
        if notificationType.showsFrequency {
            detailView.frequencyLabel.text = "알림 횟수"
        }
    }
    
    private func loadCurrentSetting() {
        // 저장된 설정 불러오기
        let defaultSetting: NotificationSetting
        
        if notificationType.showsFrequency {
            defaultSetting = NotificationSetting(
                type: .sound,
                frequency: .single,
                isEnabled: true
            )
        } else {
            defaultSetting = NotificationSetting(
                type: .sound,
                frequency: nil,
                isEnabled: true
            )
        }
        
        currentSetting = settingsStorage.getNotificationSetting(
            for: notificationType.key
        ) ?? defaultSetting
        
        updateUI()
    }
    
    private func updateUI() {
        guard let setting = currentSetting else { return }
        
        // 체크 초기화
        detailView.silentCell.accessoryType = .none
        detailView.vibrateCell.accessoryType = .none
        detailView.soundCell.accessoryType = .none
        detailView.bothCell.accessoryType = .none
        detailView.singleCell.accessoryType = .none
        detailView.continuousCell.accessoryType = .none
        
        // 현재 설정된 알림 타입에 체크 표시
        switch setting.type {
        case .mute, .muteSingle, .muteContinuous:
            detailView.silentCell.accessoryType = .checkmark
        case .vibrate, .vibrateSingle, .vibrateContinuous:
            detailView.vibrateCell.accessoryType = .checkmark
        case .sound, .soundSingle, .soundContinuous:
            detailView.soundCell.accessoryType = .checkmark
        case .both, .bothSingle, .bothContinuous:
            detailView.bothCell.accessoryType = .checkmark
        }
        
        // 무음 선택 시 주파수 버튼 비활성화
        let isFrequencyEnabled = setting.type != .mute
        
        detailView.singleCell.isUserInteractionEnabled = isFrequencyEnabled
        detailView.continuousCell.isUserInteractionEnabled = isFrequencyEnabled
        
        // 무음 시 텍스트 색상 변경
        let frequencyTextColor: UIColor = isFrequencyEnabled ? .black : .lightGray
        detailView.frequencyLabel.textColor = frequencyTextColor
        detailView.singleCell.textLabel?.textColor = frequencyTextColor
        detailView.continuousCell.textLabel?.textColor = frequencyTextColor
        
        // 주파수 설정 체크 (알 깨기는 주파수 설정 없음)
        if notificationType.showsFrequency, let frequency = setting.frequency {
            switch frequency {
            case .single:
                detailView.singleCell.accessoryType = .checkmark
            case .continuous:
                detailView.continuousCell.accessoryType = .checkmark
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func silentCellTapped() {
        updateNotificationType(.mute)
    }
    
    @objc private func vibrateCellTapped() {
        updateNotificationType(.vibrate)
    }
    
    @objc private func soundCellTapped() {
        updateNotificationType(.sound)
    }
    
    @objc private func bothCellTapped() {
        updateNotificationType(.both)
    }
    
    @objc private func singleCellTapped() {
        updateNotificationFrequency(.single)
    }
    
    @objc private func continuousCellTapped() {
        updateNotificationFrequency(.continuous)
    }
    
    private func updateNotificationType(_ type: NotificationType) {
        guard var setting = currentSetting else { return }
        
        setting.type = type
        setting.isEnabled = type != .mute
        
        if !notificationType.showsFrequency {
            setting.frequency = nil
        } else if setting.frequency == nil {
            setting.frequency = .single
        }
        
        currentSetting = setting
        settingsStorage.saveNotificationSetting(setting, for: notificationType.key)
        updateUI()
        syncSettingsWithServer()
    }
    
    private func updateNotificationFrequency(_ frequency: NotificationFrequency) {
        guard var setting = currentSetting, setting.type != .mute else { return }
        
        setting.frequency = frequency
        currentSetting = setting
        settingsStorage.saveNotificationSetting(setting, for: notificationType.key)
        updateUI()
        syncSettingsWithServer()
    }
    
    private func syncSettingsWithServer() {
        // 서버에 설정 업데이트 요청
        Task {
            do {
                let settings = collectCurrentSettings()
                let response = try await SettingsService.shared.updateSettings(settings: settings)
                if response.isSuccess {
                    print("✅ 알림 세부 설정 업데이트 성공")
                } else {
                    print("❌ 알림 세부 설정 업데이트 실패: \(response.message ?? "")")
                }
            } catch {
                print("❌ 알림 세부 설정 업데이트 오류: \(error)")
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

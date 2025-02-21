//
//  SettingsView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.18.
//

import UIKit

class SettingsView: UIView {

    // MARK: - Init
    
    static let divideLineColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private let titleLabel = UILabel().then {
        $0.text = "설정"
        $0.font = UIFont.notoSans(.medium, size: 16)
        $0.textColor = .black
    }
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "settings_wegg")
        $0.contentMode = .scaleAspectFit
    }
    
    let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.font = UIFont.notoSans(.regular, size: 20)
        $0.textColor = .black
    }
    
    let idLabel = UILabel().then {
        $0.text = "아이디"
        $0.font = UIFont.notoSans(.regular, size: 13)
        $0.textColor = UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1)
    }
    
    let profileButton = UIButton().then { $0.contentMode = .scaleAspectFit }
    
    private let divideLine1 = UIView().then { $0.backgroundColor = divideLineColor }
    
    let alarmSettingButton = SettingViewButton(title: "알림 설정")
    let featureSettingButton = SettingViewButton(title: "기능 설정")
    let privacySettingButton = SettingViewButton(title: "계정 공개 범위")
    let pointPurchaseButton = SettingViewButton(title: "포인트 구매")
    
    let refreshButton = SettingRefreshButton(title: "친구 추천 목록 새로고침",
                                             subTitle: "내 연락처에 있는 친구를 추천목록에 즉시 추가합니다")
    
    private let divideLine2 = UIView().then { $0.backgroundColor = divideLineColor }
    private let divideLine3 = UIView().then { $0.backgroundColor = divideLineColor }
    private let divideLine4 = UIView().then { $0.backgroundColor = divideLineColor }
    private let divideLine5 = UIView().then { $0.backgroundColor = divideLineColor }
    
    private func updateProfileInfo() {
        if let name = SettingsStorage.shared.getProfileName() {
            nameLabel.text = name
        }
        
        if let id = SettingsStorage.shared.getProfileId() {
            idLabel.text = id
        }
        
        if let imageData = SettingsStorage.shared.getProfileImage(),
           let image = UIImage(data: imageData) {
            profileImageView.image = image
        }
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        [
            profileImageView,
            nameLabel,
            idLabel
        ].forEach { profileButton.addSubview($0) }

        [
            titleLabel,
            profileButton,
            alarmSettingButton,
            featureSettingButton,
            privacySettingButton,
            pointPurchaseButton,
            refreshButton,
            divideLine1,
            divideLine2,
            divideLine3,
            divideLine4,
            divideLine5
        ].forEach { addSubview($0) }
        
        updateProfileInfo()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(80)
        }
        
        setupProfileConstraints()
        
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(22)
            make.height.equalTo(50)
            make.trailing.equalToSuperview().offset(-200)
        }
        
        setupDivideLineConstraints()
        
        alarmSettingButton.snp.makeConstraints { make in
            make.top.equalTo(divideLine1.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        featureSettingButton.snp.makeConstraints { make in
            make.top.equalTo(divideLine2.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        privacySettingButton.snp.makeConstraints { make in
            make.top.equalTo(divideLine3.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        pointPurchaseButton.snp.makeConstraints { make in
            make.top.equalTo(divideLine4.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        refreshButton.snp.makeConstraints { make in
            make.top.equalTo(divideLine5.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
    }
    
    private func setupProfileConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.top.bottom.leading.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(7)
            make.centerY.equalToSuperview()
        }
        
        idLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalTo(nameLabel.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupDivideLineConstraints() {
        divideLine1.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.top.equalTo(profileButton.snp.bottom).offset(19)
            make.leading.trailing.equalToSuperview()
        }
        
        divideLine2.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(alarmSettingButton.snp.bottom)
        }
        
        divideLine3.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(featureSettingButton.snp.bottom)
        }
        
        divideLine4.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(privacySettingButton.snp.bottom)
        }
        
        divideLine5.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(pointPurchaseButton.snp.bottom)
        }
    }
}

//
//  NotificationSettingView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

// NotificationSettingView.swift 개선
import UIKit

import Then
import SnapKit

class NotificationSettingView: UIView {
    
    // MARK: - Properties
    
    let friendPostToggle = SettingToggleCell()
    let commentToggle = SettingToggleCell()
    
    let locationNotificationCell = SettingDisclosureCell()
    let randomNotificationCell = SettingDisclosureCell()
    let eggBreakNotificationCell = SettingDisclosureCell()
    
    private let dividerLine1 = UIView().then { $0.backgroundColor = .clear }
    private let dividerLine2 = UIView().then { $0.backgroundColor = .clear }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .yellowBg
        
        [
            friendPostToggle,
            commentToggle,
            dividerLine1,
            locationNotificationCell,
            dividerLine2,
            randomNotificationCell,
            eggBreakNotificationCell
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        // 모든 셀에 leading, trailing 여백 21pt 적용
        friendPostToggle.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(50)
        }
        
        commentToggle.snp.makeConstraints { make in
            make.top.equalTo(friendPostToggle.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(50)
        }
        
        dividerLine1.snp.makeConstraints { make in
            make.top.equalTo(commentToggle.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(1)
        }
        
        locationNotificationCell.snp.makeConstraints { make in
            make.top.equalTo(dividerLine1.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(50)
        }
        
        dividerLine2.snp.makeConstraints { make in
            make.top.equalTo(locationNotificationCell.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(1)
        }
        
        randomNotificationCell.snp.makeConstraints { make in
            make.top.equalTo(dividerLine2.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(50)
        }
        
        eggBreakNotificationCell.snp.makeConstraints { make in
            make.top.equalTo(randomNotificationCell.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(50)
        }
    }
}

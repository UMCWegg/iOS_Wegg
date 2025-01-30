//
//  ServiceAggrementView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.20.
//

import UIKit

class ServiceAggrementView: UIView {

    // MARK: - Font
    
    private let textFont = UIFont.notoSans(.regular, size: 15)
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    let backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.tintColor = .black
    }
    
    private let mainLabel = UILabel().then {
        $0.text = "서비스 이용 동의를 진행해주세요"
        $0.textColor = .black
        $0.font = UIFont.LoginFont.title
    }
    
    private let underLineView = UIView().then {
        $0.backgroundColor = UIColor.LoginColor.labelColor
        $0.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    let agreeAllToggleButton = SignUpToggleButton(text: "약관 전체 동의")
    let serviceToggleButton = SignUpToggleButton(text: "(필수) 서비스 이용약관")
    let privacyToggleButton = SignUpToggleButton(text: "(필수) 개인정보 수집/이용 동의")
    let locationToggleButton = SignUpToggleButton(text: "(필수) 위치정보 제공")
    let marketingToggleButton = SignUpToggleButton(text: "(선택) 마케팅 수신 동의")
    
    let nextButton = LoginButton(
        style: .textOnly,
        title: "다음",
        backgroundColor: .primary
    )
    
    // MARK: - Setup
    
    private func setupViews() {
        [
            backButton,
            mainLabel,
            underLineView,
            agreeAllToggleButton,
            serviceToggleButton,
            privacyToggleButton,
            locationToggleButton,
            marketingToggleButton,
            nextButton
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.leading.equalToSuperview().offset(17)
            make.width.equalTo(8)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(22)
            make.leading.equalTo(backButton)
        }
        
        agreeAllToggleButton.snp.makeConstraints { make in
            make.leading.equalTo(backButton)
            make.top.equalTo(mainLabel.snp.bottom).offset(85)
        }
        
        underLineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalTo(backButton)
            make.top.equalTo(agreeAllToggleButton.snp.bottom).offset(22)
        }
        
        serviceToggleButton.snp.makeConstraints { make in
            make.leading.equalTo(backButton)
            make.top.equalTo(underLineView.snp.bottom).offset(22)
        }
        
        privacyToggleButton.snp.makeConstraints { make in
            make.leading.equalTo(backButton)
            make.top.equalTo(serviceToggleButton.snp.bottom).offset(12)
        }
        
        locationToggleButton.snp.makeConstraints { make in
            make.leading.equalTo(backButton)
            make.top.equalTo(privacyToggleButton.snp.bottom).offset(12)
        }
        
        marketingToggleButton.snp.makeConstraints { make in
            make.leading.equalTo(backButton)
            make.top.equalTo(locationToggleButton.snp.bottom).offset(12)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
    }
}

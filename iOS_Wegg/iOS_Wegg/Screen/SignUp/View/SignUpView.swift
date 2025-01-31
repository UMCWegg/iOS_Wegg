//
//  SignUpView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.27.
//

import UIKit

class SignUpView: UIView {

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
    
    private let appLogo = UIImageView().then {
        $0.image = UIImage(named: "wegg_text")
    }
    
    private let appIcon = UIImageView().then {
        $0.image = UIImage(named: "wegg_icon")
    }
    
    private let welcomeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }
    
    private let topStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
    }
    
    private let topMainLabel = LoginLabel(title: "에 오신 것을", type: .main)
    
    private let bottomMainLabel = LoginLabel(title: "환영해요!", type: .main)
    
    let googleLoginButton = LoginButton(
        style: .iconText,
        title: "Google로 계속하기",
        backgroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1),
        image: UIImage(named: "google_icon")
    )
        
    let kakaoLoginButton = LoginButton(
        style: .iconText,
        title: "카카오로 계속하기",
        backgroundColor: UIColor(red: 0.98, green: 0.886, blue: 0.012, alpha: 1),
        image: UIImage(named: "kakao_icon")
    )
        
    let emailLoginButton = LoginButton(
        style: .textOnly,
        title: "다른 방법으로 계속하기",
        backgroundColor: UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1)
    )
    
    // MARK: - Setup
    
    private func setupViews() {
        [appLogo, topMainLabel].forEach { topStack.addArrangedSubview($0) }
        
        [topStack, bottomMainLabel].forEach { welcomeStackView.addArrangedSubview($0) }
        
        [
            appIcon,
            welcomeStackView,
            googleLoginButton,
            kakaoLoginButton,
            emailLoginButton
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        appIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(314)
        }
        
        appLogo.snp.makeConstraints { make in
            make.width.equalTo(73)
            make.height.equalTo(26)
        }
        
        welcomeStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(appIcon.snp.bottom).offset(11)
        }
        
        emailLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(emailLoginButton.snp.top).offset(-15)
        }
        
        googleLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(kakaoLoginButton.snp.top).offset(-15)
        }
    }
}

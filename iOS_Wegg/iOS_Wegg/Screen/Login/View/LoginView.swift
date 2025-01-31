//
//  LoginView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/9/25.
//

import UIKit

import SnapKit
import Then

class LoginView: UIView {

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
    
    private let contentStack = UIStackView().then {
        $0.spacing = 7
        $0.alignment = .center
    }
    
    let googleLoginButton = LoginButton(
        style: .iconText,
        title: "Google로 로그인",
        backgroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1),
        image: UIImage(named: "google_icon")
    )
        
    let kakaoLoginButton = LoginButton(
        style: .iconText,
        title: "카카오로 로그인",
        backgroundColor: UIColor(red: 0.98, green: 0.886, blue: 0.012, alpha: 1),
        image: UIImage(named: "kakao_icon")
    )
        
    let emailLoginButton = LoginButton(
        style: .textOnly,
        title: "다른 방법으로 로그인",
        backgroundColor: UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1)
    )

    let signUpButton = UIButton().then {
        let attributedString = NSAttributedString(
            string: "회원가입",
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .baselineOffset: 6,
                .font: UIFont.notoSans(.regular, size: 16) as Any
            ]
        )
        $0.setAttributedTitle(attributedString, for: .normal)
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        [
            contentStack,
            googleLoginButton,
            kakaoLoginButton,
            emailLoginButton,
            signUpButton
        ].forEach { addSubview($0) }
        
        [
            appLogo,
            appIcon
        ].forEach { contentStack.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        appLogo.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalTo(130)
            make.height.equalTo(50)
        }
        
        appIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.width.equalTo(35)
            make.height.equalTo(52)
        }
        
        contentStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(googleLoginButton.snp.top).offset(-141)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-54)
        }
        
        emailLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(signUpButton.snp.top).offset(-16)
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

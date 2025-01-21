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
    
    private let appIcon = UIImageView().then {
        $0.image = UIImage(named: "Login/wegg_icon")
    }
    
    internal let googleLoginButton = LoginButton(
        title: "구글로 로그인",
        backgroundColor: UIColor(red: 66/255, green: 133/255, blue: 244/255, alpha: 1.0)
    )
        
    internal let kakaoLoginButton = LoginButton(
        title: "카카오로 로그인",
        backgroundColor: UIColor(red: 255/255, green: 232/255, blue: 18/255, alpha: 1.0)
    )
        
    internal let emailLoginButton = LoginButton(
        title: "다른 방법으로 로그인",
        backgroundColor: UIColor(red: 255/255, green: 232/255, blue: 18/255, alpha: 1.0)
    )

    private let signUpButton = UIButton().then {
        let attributedString = NSAttributedString(
            string: "회원가입",
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .baselineOffset: 6,
                .font: UIFont(name: "NotoSansKR-Regular", size: 16) ?? .systemFont(ofSize: 16)
            ]
        )
        $0.setAttributedTitle(attributedString, for: .normal)
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        [
            appIcon,
            googleLoginButton,
            kakaoLoginButton,
            emailLoginButton,
            signUpButton
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        
        appIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(322)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(54)
        }
        
        emailLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(17)
            make.bottom.equalTo(signUpButton.snp.top).offset(-16)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(emailLoginButton)
            make.bottom.equalTo(emailLoginButton.snp.top).offset(-15)
        }
        
        googleLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(emailLoginButton)
            make.bottom.equalTo(kakaoLoginButton.snp.top).offset(-15)
        }
    }

}

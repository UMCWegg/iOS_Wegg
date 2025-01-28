//
//  PasswordResetEmailView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.24.
//

import UIKit

class PasswordResetEmailView: UIView {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "Login/BackButton"), for: .normal)
    }
    
    private let mainLabel = UILabel().then {
        $0.text = "인증 번호를 받을 이메일을 입력해주세요"
        $0.font = UIFont.LoginFont.title
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private let emailLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = UIFont.LoginFont.label
        $0.textColor = UIColor.LoginColor.labelColor
    }
    
    let emailTextField = LoginTextField(
        placeholder: "  wegg@email.com",
        type: .email
    )
    
    let loginButton = LoginButton(
        style: .textOnly,
        title: "인증 번호 보내기",
        backgroundColor: UIColor.customColor(.primary)
    )
    
    // MARK: - Setup
    
    private func setupViews() {
        [
            backButton,
            mainLabel,
            emailLabel,
            emailTextField,
            loginButton
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
            make.width.equalTo(208)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(55)
            make.leading.equalTo(backButton)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(9)
            make.leading.equalTo(backButton)
            make.trailing.equalToSuperview().offset(-17)
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
    }
}

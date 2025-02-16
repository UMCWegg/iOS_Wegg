//
//  EmailSignUpView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.27.
//

import UIKit

class EmailSignUpView: UIView {

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
    
    let backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.tintColor = .black
    }
    
    private let mainLabel = LoginLabel(title: "이메일과 비밀번호를\n입력해주세요", type: .main)
    
    private let emailLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = UIFont.LoginFont.label
        $0.textColor = UIColor.LoginColor.labelColor
    }
    
    private let emailTextField = LoginTextField(
        placeholder: "  wegg@email.com",
        type: .email
    )
    
    private let duplicateButton = UIButton().then {
        $0.setTitle("중복확인", for: .normal)
        $0.setTitleColor(UIColor.LoginColor.labelColor, for: .normal)
        $0.titleLabel?.font = UIFont.notoSans(.medium, size: 14)
        $0.layer.cornerRadius = 18
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
    }
    
    private let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = UIFont.LoginFont.label
        $0.textColor = UIColor.LoginColor.labelColor
    }
        
    private let passwordTextField = LoginTextField(
        placeholder: "  6자 이상의 비밀번호",
        type: .password
    )
    
    private let passwordCheckLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = UIFont.LoginFont.label
        $0.textColor = UIColor.LoginColor.labelColor
    }
        
    private let passwordCheckTextField = LoginTextField(
        placeholder: "  6자 이상의 비밀번호",
        type: .password
    )
    
    let signUpButton = LoginButton(
        style: .textOnly,
        title: "회원가입",
        backgroundColor: .primary
    )
    
    var email: String? {
        get { emailTextField.text }
        set { emailTextField.text = newValue }
    }
    
    var password: String? {
        get { passwordTextField.text }
        set { passwordTextField.text = newValue }
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        [
            backButton,
            mainLabel,
            emailLabel,
            emailTextField,
            duplicateButton,
            passwordLabel,
            passwordTextField,
            passwordCheckLabel,
            passwordCheckTextField,
            signUpButton
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
    
        signUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
        
        setupContentConstraints()
    }
    
    private func setupContentConstraints() {
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(55)
            make.leading.equalTo(backButton)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(9)
            make.leading.equalTo(backButton)
            make.trailing.equalToSuperview().offset(-17)
        }
        
        duplicateButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(emailTextField).inset(4)
            make.trailing.equalTo(emailTextField).inset(4)
            make.width.equalTo(74)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(22)
            make.leading.equalTo(backButton)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(9)
            make.leading.equalTo(backButton)
            make.trailing.equalTo(emailTextField)
        }
        
        passwordCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(22)
            make.leading.equalTo(backButton)
        }
        
        passwordCheckTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordCheckLabel.snp.bottom).offset(9)
            make.leading.equalTo(backButton)
            make.trailing.equalTo(emailTextField)
        }
    }
}

//
//  EmailLoginView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.18.
//

import UIKit

class EmailLoginView: UIView {

    // MARK: - Color
    
    private let textFieldColor = UIColor(named: "Login/TextField")
    private let buttonColor = UIColor(named: "BluePrimary")
    
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
    
    private lazy var emailTextField = LoginTextField(
        placeholder: "  이메일",
        type: .email
    )
        
    private lazy var passwordTextField = LoginTextField(
        placeholder: "  비밀번호",
        type: .password
    )
    
    var email: String? {
        get { emailTextField.text }
        set { emailTextField.text = newValue }
    }
    
    var password: String? {
        get { passwordTextField.text }
        set { passwordTextField.text = newValue }
    }
    
    internal let findPasswordButton = UIButton().then {
        $0.setTitle("비밀번호를 잊으셨나요?", for: .normal)
        $0.titleLabel?.font = UIFont(name: "NotoSansKR-Regular", size: 13)
    }
    
    private lazy var loginButton = LoginButton(
        title: "로그인",
        backgroundColor: buttonColor ?? .systemPurple
    )
    
    // MARK: - Setup
    
    private func setupViews() {
        [
            emailTextField,
            passwordTextField,
            findPasswordButton,
            loginButton
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        
        emailTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(64)
            make.top.equalToSuperview().offset(332)
            make.height.equalTo(43)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(64)
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
            make.height.equalTo(43)
        }
        
        findPasswordButton.snp.makeConstraints { make in
            make.trailing.equalTo(passwordTextField.snp.trailing)
            make.top.equalTo(passwordTextField.snp.bottom).offset(8)
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(17)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
}

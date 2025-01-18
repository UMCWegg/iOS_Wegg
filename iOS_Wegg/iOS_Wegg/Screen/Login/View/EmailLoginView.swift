//
//  EmailLoginView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.18.
//

import UIKit

class EmailLoginView: UIView {

    // MARK: - Color
    
    private static let textFieldColor = UIColor(named: "textfield")
    private static let buttonColor = UIColor(named: "wegg_blue")
    
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
    
    internal let emailTextField = UITextField().then {
        $0.placeholder = " 이메일"
        $0.font = UIFont(name: "NotoSansKR-Regular", size: 13)
        $0.backgroundColor = textFieldColor
    }
    
    internal let passwordTextField = UITextField().then {
        $0.placeholder = " 비밀번호"
        $0.font = UIFont(name: "NotoSansKR-Regular", size: 13)
        $0.backgroundColor = textFieldColor
        $0.isSecureTextEntry = true
    }
    
    internal let findPasswordButton = UIButton().then {
        $0.setTitle("비밀번호를 잊으셨나요?", for: .normal)
        $0.setTitleColor(UIColor(hex: "C7C7C7"), for: .normal)
    }
    
    internal let loginButton = LoginButton(
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
            make.leading.equalToSuperview().inset(17)
            make.bottom.equalToSuperview().offset(40)
        }
    }
    
}

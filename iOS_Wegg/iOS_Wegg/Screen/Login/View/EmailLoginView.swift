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
    
    // MARK: - Font
    
    private let labelFont = UIFont(name: "NotoSansKR-Regular", size: 13)
    private let textFieldFont = UIFont(name: "NotoSansKR-Regular", size: 15)
    
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
        $0.text = "이메일과 비밀번호를 입력해주세요"
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 22)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private lazy var emailLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = labelFont
        $0.textColor = textFieldColor
    }
    
    private let emailTextField = LoginTextField(
        placeholder: "  wegg@email.com",
        type: .email
    )
    
    private lazy var passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = labelFont
        $0.textColor = textFieldColor
    }
        
    private let passwordTextField = LoginTextField(
        placeholder: "  비밀번호",
        type: .password
    )
    
    let findPasswordButton = UIButton().then {
        $0.setTitle("비밀번호를 잊으셨나요?", for: .normal)
        $0.titleLabel?.font = UIFont(name: "NotoSansKR-Regular", size: 13)
    }
    
    lazy var loginButton = LoginButton(
        title: "로그인",
        backgroundColor: UIColor(named: "YellowSecondary") ?? .systemYellow
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
            passwordLabel,
            passwordTextField,
            findPasswordButton,
            loginButton
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.leading.equalToSuperview().offset(17)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(22)
            make.leading.equalTo(backButton)
            make.width.equalTo(188)
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
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(22)
            make.leading.equalTo(backButton)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(9)
            make.leading.equalTo(backButton)
            make.trailing.equalTo(emailTextField)
        }
        
        findPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.trailing.equalTo(emailTextField)
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(17)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
}

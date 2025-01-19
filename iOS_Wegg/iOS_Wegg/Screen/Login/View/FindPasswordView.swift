//
//  FindPasswordView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.19.
//

import UIKit

class FindPasswordView: UIView {
    
    // MARK: - Color
    
    private let buttonColor = UIColor(named: "Login/SubButton")
    
    // MARK: - Font
    
    private let buttonFont = UIFont(name: "NotoSansKR-Regular", size: 13)
    
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
        placeholder: "  이메일을 입력하세요",
        type: .email
    )
    
    private lazy var requestAuthNumberButton = UIButton().then {
        $0.setTitle("인증번호 보내기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = buttonColor
        $0.titleLabel?.font = buttonFont
        $0.titleLabel?.textAlignment = .center
    }
    
    private lazy var resendButton = UIButton().then {
        $0.setTitle("재발송", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = UIColor(hex: "ECECEC")
        $0.titleLabel?.font = buttonFont
        $0.titleLabel?.textAlignment = .center
    }
    
    private lazy var authTextField = LoginTextField(
        placeholder: "  인증번호를 입력하세요",
        type: .normal
    )
    
    private lazy var confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.backgroundColor = buttonColor
        $0.titleLabel?.font = buttonFont
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.textColor = .white
    }
    
    private lazy var loginButton = LoginButton(
        title: "로그인",
        backgroundColor: UIColor(named: "BluePrimary") ?? .systemBlue
    )
    
    // MARK: - Setup
    
    private func setupViews() {
        [
            emailTextField,
            requestAuthNumberButton,
            resendButton,
            authTextField,
            confirmButton,
            loginButton
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        emailTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(64)
            make.top.equalToSuperview().offset(332)
        }
        
        requestAuthNumberButton.snp.makeConstraints { make in
            make.leading.equalTo(emailTextField.snp.leading)
            make.top.equalTo(emailTextField.snp.bottom).offset(17)
            make.height.equalTo(30)
            make.width.equalTo(151)
            make.trailing.equalTo(resendButton.snp.leading).offset(-18)
        }
        
        resendButton.snp.makeConstraints { make in
            make.trailing.equalTo(emailTextField.snp.trailing)
            make.top.equalTo(requestAuthNumberButton.snp.top)
            make.height.equalTo(requestAuthNumberButton)
            make.width.equalTo(94)
        }
        
        authTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(64)
            make.top.equalTo(requestAuthNumberButton.snp.bottom).offset(56)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(authTextField.snp.bottom).offset(21)
            make.width.equalTo(151)
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(17)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
}

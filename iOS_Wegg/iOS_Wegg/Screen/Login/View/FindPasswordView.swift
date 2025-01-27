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
        placeholder: "  wegg@email.com",
        type: .email
    )
    
    private lazy var loginButton = LoginButton(
        style: .textOnly,
        title: "인증 번호 보내기",
        backgroundColor: UIColor(named: "BluePrimary") ?? .systemBlue
    )
    
    // MARK: - Setup
    
    private func setupViews() {
        [
            emailTextField,
            loginButton
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        emailTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(64)
            make.top.equalToSuperview().offset(332)
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(17)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
}

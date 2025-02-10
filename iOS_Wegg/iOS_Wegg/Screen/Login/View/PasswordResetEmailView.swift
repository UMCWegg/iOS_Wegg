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
    
    let backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.tintColor = .black
    }
    
    private let mainLabel = LoginLabel(title: "인증 번호를 받을\n이메일을 입력해주세요", type: .main)
    
    private let emailLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = UIFont.LoginFont.label
        $0.textColor = UIColor.LoginColor.labelColor
    }
    
    let emailTextField = LoginTextField(
        placeholder: "  wegg@email.com",
        type: .email
    )
    
    let sendNumberButton = LoginButton(
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
            sendNumberButton
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
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(55)
            make.leading.equalTo(backButton)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(9)
            make.leading.equalTo(backButton)
            make.trailing.equalToSuperview().offset(-17)
        }
        
        sendNumberButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
    }
}

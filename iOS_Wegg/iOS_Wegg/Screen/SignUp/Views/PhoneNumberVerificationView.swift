//
//  PhoneNumberVerificationView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.30.
//

import UIKit

class PhoneNumberVerificationView: UIView {

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
    
    private let mainLabel = LoginLabel(title: "인증 번호를 입력해주세요", type: .main)
    
    private let subLabel = LoginLabel(title: "01000000000로 인증 번호를 보냈어요", type: .sub)
    
    private let verificationLabel = UILabel().then {
        $0.text = "인증 번호"
        $0.font = UIFont.LoginFont.label
        $0.textColor = UIColor.LoginColor.labelColor
    }
    
    let verificationTextField = VerificationTextField()
    
    let resendButton = UIButton().then {
        let attributedString = NSAttributedString(
            string: "인증번호 재발송",
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .baselineOffset: 3,
                .font: UIFont.notoSans(.regular, size: 13) ?? .systemFont(ofSize: 13)
            ]
        )
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.setTitleColor(UIColor.LoginColor.labelColor, for: .normal)
    }
    
    let nextButton = LoginButton(
        style: .textOnly,
        title: "다음",
        backgroundColor: .primary
    )
    
    let timerLabel = UILabel().then {
            $0.font = .notoSans(.regular, size: 13)
            $0.textColor = .red
            $0.textAlignment = .center
        }
    
    var phoneNumber: String = "" {
        didSet {
            self.subLabel.text = "\(phoneNumber)로 인증 번호를 보냈어요"
        }
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        [
            backButton,
            mainLabel,
            subLabel,
            verificationLabel,
            verificationTextField,
            resendButton,
            nextButton,
            timerLabel
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
            make.width.equalTo(258)
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(8)
            make.leading.equalTo(backButton)
        }
        
        verificationLabel.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(56)
            make.leading.equalTo(backButton)
        }
        
        verificationTextField.snp.makeConstraints { make in
            make.top.equalTo(verificationLabel.snp.bottom).offset(23)
            make.centerX.equalToSuperview()
            make.width.equalTo(364)
        }
        
        resendButton.snp.makeConstraints { make in
            make.top.equalTo(verificationTextField.snp.bottom).offset(9)
            make.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(resendButton.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
    }

}

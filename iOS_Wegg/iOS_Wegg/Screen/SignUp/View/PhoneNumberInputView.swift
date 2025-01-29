//
//  PhoneNumberInputView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.29.
//

import UIKit

class PhoneNumberInputView: UIView {

    // MARK: - Font
    
    static private let numTextFieldFont = UIFont.notoSans(.regular, size: 24)
    
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
        $0.setImage(UIImage(named: "BackButton"), for: .normal)
    }
    
    private let topStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
    }
    
    private let topMainLabel = UILabel().then {
        $0.text = "안녕하세요, "
        $0.font = UIFont.LoginFont.title
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private let weggyImage = UIImageView().then {
        $0.image = UIImage(named: "weggy!")
    }
    
    private let bottomMainLabel = UILabel().then {
        $0.text = "전화번호가 어떻게 되시나요?"
        $0.font = UIFont.LoginFont.title
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 0
        
    }
    
    private let titleStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }
    
    private let numberLabel = UILabel().then {
        $0.text = "전화번호"
        $0.font = UIFont.LoginFont.label
        $0.textColor = UIColor.LoginColor.labelColor
    }
    
    let firstTextField = UITextField().then {
        $0.keyboardType = .numberPad
        $0.textAlignment = .center
        $0.font = numTextFieldFont
        $0.textColor = .black
    }
    
    let secondTextField = UITextField().then {
        $0.keyboardType = .numberPad
        $0.textAlignment = .center
        $0.font = numTextFieldFont
        $0.textColor = .black
    }
    
    let thirdTextField = UITextField().then {
        $0.keyboardType = .numberPad
        $0.textAlignment = .center
        $0.font = numTextFieldFont
        $0.textColor = .black
    }
    
    let textFieldStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 58
    }
    
    let underLine = UIView().then {
        $0.heightAnchor.constraint(equalToConstant: 1).isActive = true
        $0.backgroundColor = UIColor.LoginColor.labelColor
    }
    
    let sendVerificationButton = LoginButton(
        style: .textOnly,
        title: "인증 번호 보내기",
        backgroundColor: .primary
    )
    
    // MARK: - Setup
    
    private func setupViews() {
        [topMainLabel, weggyImage].forEach { topStack.addArrangedSubview($0) }
        
        [topStack, bottomMainLabel].forEach { titleStack.addArrangedSubview($0) }
        
        [
            firstTextField,
            secondTextField,
            thirdTextField
        ].forEach { textFieldStack.addArrangedSubview($0) }
        
        [
            backButton,
            titleStack,
            numberLabel,
            textFieldStack,
            underLine,
            sendVerificationButton
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.leading.equalToSuperview().offset(17)
            make.width.equalTo(8)
        }
        
        titleStack.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(22)
            make.leading.equalTo(backButton)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.top.equalTo(titleStack.snp.bottom).offset(50)
            make.leading.equalTo(backButton)
        }
        
        textFieldStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(numberLabel.snp.bottom).offset(18)
        }
        
        underLine.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalTo(backButton)
        }
        
        sendVerificationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
    }

}

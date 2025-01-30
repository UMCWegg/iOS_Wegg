//
//  NameInputView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.30.
//

import UIKit

class NameInputView: UIView {

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
    
    private let mainLabel = UILabel().then {
        $0.text = "성함이 어떻게 되시나요?"
        $0.font = UIFont.LoginFont.title
        $0.textColor = .black
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.font = UIFont.LoginFont.label
        $0.textColor = UIColor.LoginColor.labelColor
    }
    
    let nameTextField = UITextField().then {
        $0.placeholder = "위그"
        $0.font = UIFont.notoSans(.regular, size: 24)
        $0.textColor = .black
    }
    
    private let underLine = UIView().then {
        $0.backgroundColor = UIColor.LoginColor.labelColor
    }
    
    let nextButton = LoginButton(
        style: .textOnly,
        title: "다음",
        backgroundColor: .primary
    )
    
    // MARK: - Setup
    
    private func setupViews() {
        [
            backButton,
            mainLabel,
            nameLabel,
            nameTextField,
            underLine,
            nextButton
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
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(81)
            make.leading.equalTo(backButton)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.equalTo(backButton)
            make.top.equalTo(nameLabel.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
        }
        
        underLine.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(6)
            make.height.equalTo(1)
            make.centerX.equalToSuperview()
            make.leading.equalTo(backButton)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
    }
}

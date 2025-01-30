//
//  NickNameInputView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.31.
//

import UIKit

class NickNameInputView: UIView {

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
        $0.text = "'위그'님,\n나만의 아이디를 만들어보세요!"
        $0.font = UIFont.LoginFont.title
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private let nickNameLabel = UILabel().then {
        $0.text = "아이디"
        $0.font = UIFont.LoginFont.label
        $0.textColor = UIColor.LoginColor.labelColor
    }
    
    let nickNameTextField = UITextField().then {
        $0.placeholder = "weggy"
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
            nickNameLabel,
            nickNameTextField,
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
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(55)
            make.leading.equalTo(backButton)
        }
        
        nickNameTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.equalTo(backButton)
            make.top.equalTo(nickNameLabel.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
        }
        
        underLine.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(6)
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

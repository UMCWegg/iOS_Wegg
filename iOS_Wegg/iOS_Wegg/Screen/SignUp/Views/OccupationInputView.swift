//
//  OccupationInputView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.31.
//

import UIKit

class OccupationInputView: UIView {
    
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
    
    private let mainLabel = LoginLabel(title: "'위그'님,\n직업이 어떻게 되시나요?", type: .main)
    
    let passButton = UIButton().then {
        $0.setTitle("건너뛰기", for: .normal)
        $0.setTitleColor(UIColor.LoginColor.labelColor, for: .normal)
        $0.titleLabel?.font = UIFont.notoSans(.regular, size: 12)
    }
    
    private let subLabel = LoginLabel(title: "더 좋은 앱을 만드는데 자료로 사용되어요", type: .sub)
    
    private let occupationLabel = UILabel().then {
        $0.text = "신분"
        $0.font = UIFont.LoginFont.label
        $0.textColor = UIColor.LoginColor.labelColor
    }
    
    let occupationDropdown = DropdownButton().then {
        $0.configure(
            options: UserOccupation.allCases,
            placeholder: UserOccupation.employee.displayName
        )
    }
    
    let nextButton = LoginButton(
        style: .textOnly,
        title: "다음",
        backgroundColor: .primary
    )
    
    var nameText: String = "" {
        didSet {
            self.mainLabel.text = "'\(nameText)'님,\n직업이 어떻게 되시나요?"
        }
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        [
            backButton,
            mainLabel,
            passButton,
            subLabel,
            occupationLabel,
            occupationDropdown,
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
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(8)
            make.leading.equalTo(backButton)
        }
        
        passButton.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.trailing.equalToSuperview().offset(-17)
        }
        
        occupationLabel.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(30)
            make.leading.equalTo(backButton)
        }
        
        occupationDropdown.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalTo(backButton)
            make.top.equalTo(occupationLabel.snp.bottom).offset(9)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
    }
}

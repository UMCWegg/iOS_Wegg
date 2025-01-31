//
//  SignUpCompleteView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.01.
//

import UIKit

class SignUpCompleteView: UIView {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let appLogo = UIImageView().then {
        $0.image = UIImage(named: "wegg_text")
        $0.contentMode = .scaleAspectFit
    }
    
    private let topMainLabel = LoginLabel(title: "에 오신 것을", type: .main)
    
    private let bottomMainLabel = LoginLabel(title: "환영합니다!", type: .main)
    
    private let topStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
    }
    
    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }
    
    private let applaudLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 48)
        $0.text = "👏"
    }
    
    let nextButton = LoginButton(
        style: .textOnly,
        title: "다음",
        backgroundColor: .primary
    )
    
    // MARK: - Setup
    
    private func setupViews() {
        [appLogo, topMainLabel].forEach { topStackView.addArrangedSubview($0) }
        
        [topStackView, bottomMainLabel].forEach { mainStackView.addArrangedSubview($0) }
        
        [
            mainStackView,
            applaudLabel,
            nextButton
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        appLogo.snp.makeConstraints { make in
            make.width.equalTo(73)
            make.height.equalTo(26)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(280)
        }
        
        applaudLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainStackView.snp.bottom).offset(41)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
    }
}

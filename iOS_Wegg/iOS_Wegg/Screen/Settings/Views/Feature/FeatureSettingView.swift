//
//  FeatureSettingView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

import UIKit

import Then
import SnapKit

class FeatureSettingView: UIView {
    
    // MARK: - Properties
    
    let locationToggle = SettingToggleCell()
    let randomToggle = SettingToggleCell()
    let eggBreakButton = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.notoSans(.regular, size: 14)
        $0.contentHorizontalAlignment = .left
        $0.backgroundColor = .white
        $0.tintColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 300, bottom: 0, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        $0.layer.cornerRadius = 22
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 0.49, green: 0.31, blue: 0.18, alpha: 1).cgColor
    }
    
    let warningLabel = UILabel().then {
        $0.font = .notoSans(.regular, size: 13)
        $0.textColor = UIColor(red: 1, green: 0.5, blue: 0.2, alpha: 1)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.isHidden = true
    }
    
    private let dividerLine1 = UIView().then
    { $0.backgroundColor = .lightGray.withAlphaComponent(0.3) }
    private let dividerLine2 = UIView().then
    { $0.backgroundColor = .lightGray.withAlphaComponent(0.3) }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .white
        
        [
            locationToggle,
            dividerLine1,
            randomToggle,
            dividerLine2,
            eggBreakButton,
            warningLabel
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        locationToggle.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        dividerLine1.snp.makeConstraints { make in
            make.top.equalTo(locationToggle.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        randomToggle.snp.makeConstraints { make in
            make.top.equalTo(dividerLine1.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        dividerLine2.snp.makeConstraints { make in
            make.top.equalTo(randomToggle.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        eggBreakButton.snp.makeConstraints { make in
            make.top.equalTo(dividerLine2.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(22)
            make.height.equalTo(50)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(eggBreakButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

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

    let eggBreakCell = SettingDisclosureCell()
    
    let warningLabel = UILabel().then {
        $0.font = .notoSans(.regular, size: 13)
        $0.textColor = UIColor(red: 1, green: 0.5, blue: 0.2, alpha: 1)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.isHidden = true
    }
    
    private let dividerLine1 = UIView().then
    { $0.backgroundColor = .clear }
    private let dividerLine2 = UIView().then
    { $0.backgroundColor = .clear }
    
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
            eggBreakCell,
            warningLabel
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        locationToggle.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(50)
        }
        
        dividerLine1.snp.makeConstraints { make in
            make.top.equalTo(locationToggle.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(1)
        }
        
        randomToggle.snp.makeConstraints { make in
            make.top.equalTo(dividerLine1.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(50)
        }
        
        dividerLine2.snp.makeConstraints { make in
            make.top.equalTo(randomToggle.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(1)
        }
        
        eggBreakCell.snp.makeConstraints { make in
            make.top.equalTo(dividerLine2.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(50)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(eggBreakCell.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

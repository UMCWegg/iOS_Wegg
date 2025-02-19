//
//  SettingRefreshButton.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.18.
//

import UIKit

class SettingRefreshButton: UIButton {
    
    // MARK: - Properties
    
    private let mainTitleLabel = UILabel().then {
        $0.font = UIFont.notoSans(.regular, size: 14)
        $0.textColor = .black
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.notoSans(.regular, size: 13)
        $0.textColor = UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1)
        $0.numberOfLines = 0
    }
    
    let refreshButton = UIButton().then {
        $0.setImage(UIImage(named: "refresh"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }
    
    // MARK: - Init
    
    init(title: String, subTitle: String) {
        super.init(frame: .zero)
        setupButton()
        mainTitleLabel.text = title
        subTitleLabel.text = subTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupButton() {
        backgroundColor = .clear
        [
            mainTitleLabel,
            subTitleLabel,
            refreshButton
        ].forEach { addSubview($0) }
        
        mainTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(22)
            make.top.equalToSuperview().offset(22)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(mainTitleLabel)
            make.top.equalTo(mainTitleLabel.snp.bottom)
            make.bottom.equalToSuperview().inset(22)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.top.equalTo(mainTitleLabel)
            make.height.width.equalTo(17)
            make.trailing.equalToSuperview().inset(22)
        }
    }
}

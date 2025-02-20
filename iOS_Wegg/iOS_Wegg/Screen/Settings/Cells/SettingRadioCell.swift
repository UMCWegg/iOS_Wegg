//
//  SettingRadioCell.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.18.
//

import UIKit

import Then
import SnapKit

class SettingRadioCell: SettingBaseCell {
    
    // MARK: - Properties
    
    private let arrowImageView = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark")
        $0.tintColor = .primary
        $0.contentMode = .scaleAspectFit
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupArrowImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupArrowImageView() {
        containerView.addSubview(arrowImageView)
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
            make.width.equalTo(11)
            make.height.equalTo(9)
        }
    }
    
    // MARK: - Functions
    
    override func configure(with title: String) {
        super.configure(with: title)
    }
     
}

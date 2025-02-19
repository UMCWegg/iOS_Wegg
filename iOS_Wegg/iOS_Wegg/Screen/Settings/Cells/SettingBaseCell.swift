//
//  SettingBaseCell.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.17.
//

import UIKit

import Then
import SnapKit

class SettingBaseCell: UITableViewCell {
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        
        selectionStyle = .default
        
        let backGroundView = UIView()
        backGroundView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        selectedBackgroundView = backGroundView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    let titleLabel = UILabel().then {
        $0.font = UIFont.notoSans(.regular, size: 14)
        $0.textColor = .black
    }
    
    let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 25
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 0.49, green: 0.31, blue: 0.18, alpha: 1).cgColor
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(17)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}

//
//  SettingDisclosureCell.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.18.
//

import UIKit

import Then
import SnapKit

class SettingDisclosureCell: SettingBaseCell {

    // MARK: - Properties
    
    let detailLabel = UILabel().then {
        $0.font = .notoSans(.regular, size: 14)
        $0.textColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1)
        $0.textAlignment = .right
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDetailLabel()
        
        // 표준 disclosure indicator 사용
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupDetailLabel() {
        containerView.addSubview(detailLabel)
        
        detailLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-30) // disclosure indicator 공간 확보
        }
    }
    
    // MARK: - Functions
    
    func configure(with title: String, detail: String? = nil) {
        super.configure(with: title)
        
        if let detail = detail {
            detailLabel.text = detail
            detailLabel.isHidden = false
        } else {
            detailLabel.isHidden = true
        }
    }
}

extension SettingDisclosureCell {
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
}

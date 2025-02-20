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
    
    let arrowImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1)
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [detailLabel, arrowImageView]).then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStackView()
        
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupStackView() {
        containerView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.width.equalTo(6)
            make.height.equalTo(12)
        }
    }
    
    // MARK: - Functions
    
    func configure(with title: String, detail: String? = nil) {
        super.configure(with: title)
        
        if let detail = detail {
            detailLabel.text = detail
            detailLabel.isHidden = false
            
            // 텍스트가 있을 때의 제약조건
            detailLabel.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalTo(arrowImageView.snp.leading).offset(-8)
            }
        } else {
            detailLabel.isHidden = true
        }
    }
}

import UIKit

extension SettingDisclosureCell {
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
}

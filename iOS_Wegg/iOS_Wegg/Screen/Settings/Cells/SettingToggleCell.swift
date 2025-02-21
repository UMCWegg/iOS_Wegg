//
//  SettingToggleCell.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.18.
//

import UIKit

import Then
import SnapKit

class SettingToggleCell: SettingBaseCell {
    
    // MARK: - Properties
    
    let toggleSwitch = UISwitch().then {
        $0.onTintColor = .primary
    }
    
    var toggleHandler: ((Bool) -> Void)?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupToggleSwitch()
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupToggleSwitch() {
        containerView.addSubview(toggleSwitch)
        
        toggleSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
        }
        
        toggleSwitch.addTarget(self, action: #selector(toggleSwitchChanged), for: .valueChanged)
    }
    
    // MARK: - Functions
    
    func configure(with title: String, isOn: Bool) {
        super.configure(with: title)
        toggleSwitch.isOn = isOn
    }
    
    @objc private func toggleSwitchChanged(_ sender: UISwitch) {
        toggleHandler?(sender.isOn)
    }
}

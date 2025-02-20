//
//  PrivacySettingView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

import UIKit

import Then
import SnapKit

class PrivacySettingView: UIView {
    
    // MARK: - Properties
    
    let allCell = UITableViewCell(style: .default, reuseIdentifier: nil).then {
        $0.backgroundColor = .white
        $0.selectionStyle = .none
        $0.textLabel?.text = "전체 공개"
        $0.textLabel?.font = .systemFont(ofSize: 16)
        $0.textLabel?.textColor = .black
    }
    
    let mutualCell = UITableViewCell(style: .default, reuseIdentifier: nil).then {
        $0.backgroundColor = .white
        $0.selectionStyle = .none
        $0.textLabel?.text = "맞팔만 공개"
        $0.textLabel?.font = .systemFont(ofSize: 16)
        $0.textLabel?.textColor = .black
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    private let dividerLine = UIView().then { $0.backgroundColor = .gray.withAlphaComponent(0.3) }
    
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
        backgroundColor = .yellowBg
        
        [
            allCell,
            dividerLine,
            mutualCell
        ].forEach { containerView.addSubview($0) }
        
        addSubview(containerView)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        allCell.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        dividerLine.snp.makeConstraints { make in
            make.top.equalTo(allCell.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(1)
        }
        
        mutualCell.snp.makeConstraints { make in
            make.top.equalTo(dividerLine.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }
    }
}

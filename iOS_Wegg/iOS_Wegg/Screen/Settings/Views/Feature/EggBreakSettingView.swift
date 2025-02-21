//
//  EggBreakSettingView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

import UIKit

import Then
import SnapKit

class EggBreakSettingView: UIView {
    
    // MARK: - Properties
    
    let onCell = UITableViewCell(style: .default, reuseIdentifier: nil).then {
        $0.backgroundColor = .white
        $0.selectionStyle = .none
        $0.textLabel?.text = "끔"
        $0.textLabel?.font = .notoSans(.regular, size: 16)
        $0.textLabel?.textColor = .black
    }
    
    let offCell = UITableViewCell(style: .default, reuseIdentifier: nil).then {
        $0.backgroundColor = .white
        $0.selectionStyle = .none
        $0.textLabel?.text = "맞팔만 허용"
        $0.textLabel?.font = .notoSans(.regular, size: 16)
        $0.textLabel?.textColor = .black
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.brown.cgColor
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
            onCell,
            dividerLine,
            offCell
        ].forEach { containerView.addSubview($0) }
        
        addSubview(containerView)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        onCell.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        dividerLine.snp.makeConstraints { make in
            make.top.equalTo(onCell.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(1)
        }
        
        offCell.snp.makeConstraints { make in
            make.top.equalTo(dividerLine.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }
    }
}

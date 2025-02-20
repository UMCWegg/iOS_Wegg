//
//  NotificationDetailView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

import UIKit

import Then
import SnapKit

class NotificationDetailView: UIView {
    
    // MARK: - Properties
    
    let modeLabel = UILabel().then {
        $0.text = "모드"
        $0.font = .notoSans(.medium, size: 17)
        $0.textColor = .black
    }
    
    let silentCell = UITableViewCell(style: .default, reuseIdentifier: nil).then {
        $0.backgroundColor = .white
        $0.selectionStyle = .none
        $0.textLabel?.font = .notoSans(.regular, size: 16)
        $0.textLabel?.textColor = .black
    }
    
    let vibrateCell = UITableViewCell(style: .default, reuseIdentifier: nil).then {
        $0.backgroundColor = .white
        $0.selectionStyle = .none
        $0.textLabel?.font = .notoSans(.regular, size: 16)
        $0.textLabel?.textColor = .black
    }
    
    let soundCell = UITableViewCell(style: .default, reuseIdentifier: nil).then {
        $0.backgroundColor = .white
        $0.selectionStyle = .none
        $0.textLabel?.font = .notoSans(.regular, size: 16)
        $0.textLabel?.textColor = .black
    }
    
    let bothCell = UITableViewCell(style: .default, reuseIdentifier: nil).then {
        $0.backgroundColor = .white
        $0.selectionStyle = .none
        $0.textLabel?.font = .notoSans(.regular, size: 16)
        $0.textLabel?.textColor = .black
    }
    
    let frequencyLabel = UILabel().then {
        $0.font = .notoSans(.medium, size: 17)
        $0.textColor = .black
    }
    
    let singleCell = UITableViewCell(style: .default, reuseIdentifier: nil).then {
        $0.backgroundColor = .white
        $0.selectionStyle = .none
        $0.textLabel?.text = "단발"
        $0.textLabel?.font = .notoSans(.regular, size: 16)
        $0.textLabel?.textColor = .black
    }
    
    let continuousCell = UITableViewCell(style: .default, reuseIdentifier: nil).then {
        $0.backgroundColor = .white
        $0.selectionStyle = .none
        $0.textLabel?.text = "연속"
        $0.textLabel?.font = .notoSans(.regular, size: 16)
        $0.textLabel?.textColor = .black
    }
    
    private let modeSectionView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.brown.cgColor
    }
    
    private let frequencySectionView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.brown.cgColor
    }
    
    private let dividerLine1 = UIView().then { $0.backgroundColor = .gray.withAlphaComponent(0.3) }
    private let dividerLine2 = UIView().then { $0.backgroundColor = .gray.withAlphaComponent(0.3) }
    private let dividerLine3 = UIView().then { $0.backgroundColor = .gray.withAlphaComponent(0.3) }
    
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
        
        // 모드 섹션
        [
            silentCell,
            dividerLine1,
            vibrateCell,
            dividerLine2,
            soundCell,
            dividerLine3,
            bothCell
        ].forEach { modeSectionView.addSubview($0) }
        
        // 주파수 섹션
        let dividerLine4 = UIView().then { $0.backgroundColor = .gray.withAlphaComponent(0.3) }
        frequencySectionView.addSubview(singleCell)
        frequencySectionView.addSubview(dividerLine4)
        frequencySectionView.addSubview(continuousCell)
        
        dividerLine4.snp.makeConstraints { make in
            make.top.equalTo(singleCell.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        [
            modeLabel,
            modeSectionView,
            frequencyLabel,
            frequencySectionView
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        // 모드 라벨
        modeLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        // 모드 섹션
        modeSectionView.snp.makeConstraints { make in
            make.top.equalTo(modeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        silentCell.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        dividerLine1.snp.makeConstraints { make in
            make.top.equalTo(silentCell.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(1)
        }
        
        vibrateCell.snp.makeConstraints { make in
            make.top.equalTo(dividerLine1.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        dividerLine2.snp.makeConstraints { make in
            make.top.equalTo(vibrateCell.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(1)
        }
        
        soundCell.snp.makeConstraints { make in
            make.top.equalTo(dividerLine2.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        dividerLine3.snp.makeConstraints { make in
            make.top.equalTo(soundCell.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(1)
        }
        
        bothCell.snp.makeConstraints { make in
            make.top.equalTo(dividerLine3.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }
        
        // 주파수 라벨
        frequencyLabel.snp.makeConstraints { make in
            make.top.equalTo(modeSectionView.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
        }
        
        // 주파수 섹션
        frequencySectionView.snp.makeConstraints { make in
            make.top.equalTo(frequencyLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        singleCell.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        continuousCell.snp.makeConstraints { make in
            make.top.equalTo(singleCell.snp.bottom).offset(1)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }
    }
}

// UITableViewCell 확장 - configure 메서드 추가
extension UITableViewCell {
    func configure(with title: String) {
        textLabel?.text = title
    }
}

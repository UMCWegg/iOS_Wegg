//
//  ScheduleCardCell.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/10/25.
//

import UIKit
import Then

protocol ScheduleCardCellDelegate: AnyObject {
    func toggleSwitchAlarm(action: UIAction)
}

class ScheduleCardCell: UITableViewCell {
    static let reuseIdentifier = "ScheduleCell"
    
    weak var delegate: ScheduleCardCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .yellowWhite
        contentView.backgroundColor = .clear
        selectionStyle = .none // 셀 선택 효과 제거
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 24
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.secondary.cgColor
        $0.layer.masksToBounds = true
    }
    
    private lazy var yellowLogoIcon = UIImageView().then {
        $0.image = UIImage(named: "yellow_wegg_icon")
        $0.contentMode = .scaleAspectFit
    }
    private lazy var dateLabel = UILabel().then {
        $0.font = .notoSans(.medium, size: 14)
        $0.textColor = .black
    }
    private lazy var titleLabel = UILabel().then {
        $0.font = .notoSans(.bold, size: 20)
        $0.textColor = .black
    }
    private lazy var timeRangeLabel = UILabel().then {
        $0.font = .notoSans(.medium, size: 16)
        $0.textColor = .customGray
    }
    private lazy var toggleSwitch = UISwitch().then {
        $0.onTintColor = .primary
        $0.addAction(UIAction { [weak self] in
            self?.delegate?.toggleSwitchAlarm(action: $0)
        }, for: .valueChanged)
    }
    
    private lazy var logoTitleStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 4
    }
    
    // 테이블 datasoruce 주입
    func configure(with schedule: ScheduleModel) {
        dateLabel.text = schedule.date
        titleLabel.text = schedule.location
        timeRangeLabel.text = schedule.timeRange
        toggleSwitch.isOn = schedule.isOn
    }
}

// MARK: - Set Up Extension

private extension ScheduleCardCell {
    func setupView() {
        addComponents()
        constraints()
    }
    
    func addComponents() {
        contentView.addSubview(containerView)
        [yellowLogoIcon, titleLabel].forEach(logoTitleStack.addArrangedSubview)
        [
            dateLabel,
            logoTitleStack,
            timeRangeLabel,
            toggleSwitch
        ].forEach(containerView.addSubview)
        
        yellowLogoIcon.snp.makeConstraints { make in
            make.width.height.equalTo(16)
        }
    }
    
    func constraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19)
            make.leading.trailing.equalToSuperview().inset(21)
            make.bottom.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.lessThanOrEqualToSuperview().offset(20)
            make.width.equalTo(160)
        }
        
        logoTitleStack.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.leading.lessThanOrEqualToSuperview().offset(20)
            make.width.equalTo(230)
            make.height.equalTo(26)
        }
        
        timeRangeLabel.snp.makeConstraints { make in
            make.top.equalTo(logoTitleStack.snp.bottom).offset(5)
            make.leading.lessThanOrEqualToSuperview().offset(20)
            make.width.equalTo(160)
        }
        
        toggleSwitch.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
    }
}

//
//  ScheduleCell.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/10/25.
//

import UIKit

class ScheduleCardCell: UITableViewCell {
    static let reuseIdentifier = "ScheduleCell"
    
    private lazy var titleLabel = UILabel()
    private lazy var timeLabel = UILabel()
    private lazy var toggleSwitch = UISwitch()
    
    func configure(with schedule: Schedule) {
        titleLabel.text = schedule.location
        timeLabel.text = schedule.timeRange
        toggleSwitch.isOn = schedule.isOn
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .green // 임시 색상 설정
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        // Auto Layout 설정 (예: SnapKit 사용)
    }
}

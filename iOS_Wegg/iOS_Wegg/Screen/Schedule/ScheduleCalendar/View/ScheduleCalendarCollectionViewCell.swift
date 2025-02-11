//
//  ScheduleCalendarCell.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/11/25.
//

import UIKit
import SnapKit

class ScheduleCalendarCell: UICollectionViewCell {
    static let identifier = "ScheduleCalendarCell"
    
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .primary
        contentView.layer.cornerRadius = contentView.bounds.width / 2
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.brown.cgColor

        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(date: Int?, isSelected: Bool) {
        label.text = date.map { "\($0)" }
        if date == nil {
            contentView.isHidden = true
            label.isHidden = true
        } else {
            contentView.isHidden = false
            contentView.backgroundColor = isSelected ? .red : .blue
        }
    }
    
    private func setupView() {
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

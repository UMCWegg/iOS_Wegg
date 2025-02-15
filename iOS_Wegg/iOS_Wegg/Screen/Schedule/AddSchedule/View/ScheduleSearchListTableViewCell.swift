//
//  ScheduleSearchListTableViewCell.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/15/25.
//

import UIKit

class ScheduleSearchListTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ScheduleSearchListTableViewCell"

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

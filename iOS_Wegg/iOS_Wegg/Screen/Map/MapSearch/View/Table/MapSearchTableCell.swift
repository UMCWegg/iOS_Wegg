//
//  MapSearchTableCell.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/19/25.
//

import UIKit

class MapSearchTableCell: UITableViewCell {

    static let reuseIdentifier = "MapSearchTableCell"

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var resultLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .notoSans(.medium, size: 14)
        $0.numberOfLines = 1
    }
    
    private lazy var dividedLine = UIView().then {
        $0.backgroundColor = .gray1
        $0.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
    
    public func configure(with text: String) {
        resultLabel.text = text
    }
    
    private func setupView() {
        addComponents()
        constraints()
    }
    
    private func addComponents() {
        addSubview(resultLabel)
        addSubview(dividedLine)
    }
    
    private func constraints() {
        resultLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.lessThanOrEqualToSuperview().offset(21)
            make.width.equalToSuperview().offset(10)
        }
        
        dividedLine.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
    }
}

//
//  NotiCell.swift
//  iOS_Wegg
//
//  Created by KKM on 1/31/25.
//

import UIKit
import SnapKit
import Then

class NotiCell: UITableViewCell {
    static let identifier = "NotiCell"

    private let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "profileImage")
        $0.backgroundColor = .clear
    }

    private let messageLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 2
    }

    private let timeLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .gray
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [messageLabel, timeLabel]).then {
            $0.axis = .horizontal
            $0.spacing = 10
        }

        addSubview(profileImageView)
        addSubview(stackView)

        profileImageView.snp.makeConstraints {
            $0.size.equalTo(45)
            $0.leading.equalToSuperview().offset(21.5)
            $0.centerY.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(13.5)
            $0.centerY.equalToSuperview()
        }
    }

    func configure(with text: String, time: String) {
        messageLabel.text = text
        timeLabel.text = time
    }
}

//
//  NotiCell.swift
//  iOS_Wegg
//
//  Created by KKM on 1/31/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class NotiCell: UITableViewCell {
    static let identifier = "NotiCell"

    private let profileImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 22.5 // 반지름 값 설정 (45 / 2)
        $0.clipsToBounds = true // 이미지가 뷰의 경계를 넘어가지 않도록 설정
    }

    private let messageLabel = UILabel().then {
        $0.font = .notoSans(.regular, size: 15)
        $0.numberOfLines = 2
    }

    private let timeLabel = UILabel().then {
        $0.font = .notoSans(.regular, size: 13)
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

    // configure 메서드 수정
    func configure(with text: String, time: String, imageUrl: String?) {
        messageLabel.text = text
        timeLabel.text = time

        // imageUrl이 nil이 아닌 경우에만 Kingfisher를 사용하여 이미지 로드
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            profileImageView.kf.setImage(with: url)
        } else {
            // imageUrl이 nil인 경우 기본 이미지 설정 (선택 사항)
            profileImageView.image = UIImage(named: "profileImage")
        }
    }
}

//
//  FollowCell.swift
//  iOS_Wegg
//
//  Created by KKM on 1/31/25.
//

import UIKit
import SnapKit
import Then

enum FollowCellType {
    case request
    case recommendation
}

class FollowCell: UITableViewCell {
    
    static let identifier = "FollowCell"
    
    private let profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    
    private let usernameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .black
    }
    
    private let realNameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .gray
    }
    
    private let actionButton = UIButton().then {
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.orange.cgColor
        $0.setTitleColor(.orange, for: .normal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [usernameLabel, realNameLabel]).then {
            $0.axis = .vertical
            $0.spacing = 2
        }

        contentView.addSubview(profileImageView)
        contentView.addSubview(stackView)
        contentView.addSubview(actionButton)

        profileImageView.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }

        actionButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(30)
        }
    }
    
    func configure(with username: String, name: String, type: FollowCellType) {
        usernameLabel.text = username
        realNameLabel.text = name
        
        switch type {
        case .request:
            actionButton.setTitle("확인", for: .normal)
            let deleteButton = UIButton().then {
                $0.setTitle("삭제", for: .normal)
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
                $0.setTitleColor(.red, for: .normal)
            }
            contentView.addSubview(deleteButton)
            deleteButton.snp.makeConstraints {
                $0.trailing.equalTo(actionButton.snp.leading).offset(-8)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(50)
                $0.height.equalTo(30)
            }
        case .recommendation:
            actionButton.setTitle("팔로우", for: .normal)
        }
    }
}

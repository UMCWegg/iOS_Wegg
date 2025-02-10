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
        $0.font = .notoSans(.regular, size: 16)
        $0.textColor = .black
    }
    
    private let realNameLabel = UILabel().then {
        $0.font = .notoSans(.regular, size: 14)
        $0.textColor = .gray
    }
    
    // 확인 버튼 뷰
    private let actionButton = UIView().then {
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.secondary.cgColor
        $0.layer.backgroundColor = UIColor.primary.cgColor
    }
    private let actionLabel = UILabel().then {
        $0.text = "확인"
        $0.textColor = .secondary
        $0.font = .notoSans(.regular, size: 13)
    }
    
    // 취소 버튼 뷰
    private let deleteButton = UIView().then {
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.secondary.cgColor
    }
    private let deleteLabel = UILabel().then {
        $0.text = "취소"
        $0.textColor = .secondary
        $0.font = .notoSans(.regular, size: 13)
    }
    
    // 팔로우 버튼 뷰
    private let followButton = UIView().then {
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.secondary.cgColor
        $0.layer.backgroundColor = UIColor.primary.cgColor
    }
    private let followLabel = UILabel().then {
        $0.text = "팔로우"
        $0.textColor = .secondary
        $0.font = .notoSans(.regular, size: 13)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupActions()
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
        contentView.addSubview(deleteButton)
        contentView.addSubview(followButton)

        // 프로필 이미지
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }

        // 스택 뷰 (유저명 + 실명)
        stackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }

        // 취소 버튼 (오른쪽에 위치)
        deleteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(30)
        }

        // 확인 버튼 (취소 버튼의 왼쪽에 위치)
        actionButton.snp.makeConstraints {
            $0.trailing.equalTo(deleteButton.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(30)
        }

        // 팔로우 버튼 (오른쪽에 위치)
        followButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(30)
        }

        // 버튼 내부 라벨 추가
        actionButton.addSubview(actionLabel)
        deleteButton.addSubview(deleteLabel)
        followButton.addSubview(followLabel)

        actionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        deleteLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        followLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setupActions() {
        // 확인 버튼 탭 제스처 추가
        let actionTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(actionButtonTapped)
        )
        actionButton.addGestureRecognizer(actionTapGesture)
        actionButton.isUserInteractionEnabled = true

        // 취소 버튼 탭 제스처 추가
        let deleteTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(deleteButtonTapped)
        )
        deleteButton.addGestureRecognizer(deleteTapGesture)
        deleteButton.isUserInteractionEnabled = true

        // 팔로우 버튼 탭 제스처 추가
        let followTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(followButtonTapped)
        )
        followButton.addGestureRecognizer(followTapGesture)
        followButton.isUserInteractionEnabled = true
    }
    
    @objc private func actionButtonTapped() {
        print("확인 버튼 탭")
    }
    
    @objc private func deleteButtonTapped() {
        print("취소 버튼 탭")
    }
    
    @objc private func followButtonTapped() {
        print("팔로우 버튼 탭")
    }
    
    func configure(with username: String, name: String, type: FollowCellType) {
        usernameLabel.text = username
        realNameLabel.text = name
        
        switch type {
        case .request:
            actionButton.isHidden = false
            deleteButton.isHidden = false
            followButton.isHidden = true
        case .recommendation:
            actionButton.isHidden = true
            deleteButton.isHidden = true
            followButton.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}

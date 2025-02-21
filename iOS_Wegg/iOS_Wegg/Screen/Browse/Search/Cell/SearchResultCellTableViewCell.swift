//
//  SearchResultCellTableViewCell.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/18/25.
//

import UIKit

class SearchResultCell: UITableViewCell {
    // MARK: - Property
    
    static let identifier = "SearchResultCell"
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    private let usernameLabel = UILabel().then {
        $0.font = .notoSans(.medium, size: 16)
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    /// ✅ `UserSearchResult`를 받아 UI 업데이트
        func configure(with user: UserSearchResult) {
            usernameLabel.text = user.accountId // ✅ accountId를 username으로 표시
            profileImageView.setImage(from: user.profileImage, placeholder: "profile_placeholder")
        }
    
    private func setupView() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(profileImageView.snp.right).offset(12)
        }
    }
    
    func configure(with user: User) {
        profileImageView.image = user.profileImage
        usernameLabel.text = user.username
    }
}

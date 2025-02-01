//
//  CommentCell.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/1/25.
//

import UIKit

class CommentCell: UITableViewCell {
    
    static let identifier = "CommentCell"
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Property
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    private let usernameLabel = UILabel().then {
        $0.font = UIFont.notoSans(.medium, size: 14)
        $0.textColor = .black
    }
    
    private let commentLabel = UILabel().then {
        $0.font = UIFont.notoSans(.regular, size: 14)
        $0.textColor = .darkGray
        $0.numberOfLines = 0
    }
    
    // MARK: - Methods
    
    private func setupView() {
        [profileImageView,
         usernameLabel,
         commentLabel].forEach{ self.addSubview($0)}
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(10)
            $0.width.height.equalTo(40)
        }
        
        usernameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(14)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(usernameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(usernameLabel)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configure(with model: CommentModel) {
        profileImageView.image = model.profileImage
        usernameLabel.text = model.userName
        commentLabel.text = model.commentText
    }
}

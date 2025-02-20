//
//  ContactFriendCell.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

import UIKit

class ContactFriendCell: UITableViewCell {
    
    // MARK: - Properties
    
    enum FollowState {
        case follow
        case pending
        case success
        
        var title: String {
            switch self {
            case .follow: return "팔로우"
            case .pending: return "요청중"
            case .success: return "성공!"
            }
        }
    }
    
    private var friendID: Int = 0
    var followStateChanged: ((Int, FollowState) -> Void)?
    
    private var currentState: FollowState = .follow
    
    let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    let nameLabel = UILabel().then {
        $0.font = .notoSans(.medium, size: 14)
        $0.textColor = .black
    }
    
    let accountLabel = UILabel().then {
        $0.font = .notoSans(.regular, size: 12)
        $0.textColor = .customGray2
    }
    
    let followButton = UIButton().then {
        $0.layer.cornerRadius = 15
        $0.titleLabel?.font = .notoSans(.medium, size: 12)
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupActions()
        setState(.follow)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        [profileImageView, nameLabel, accountLabel, followButton].forEach {
            contentView.addSubview($0)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.top.equalTo(profileImageView).offset(2)
        }
        
        accountLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.bottom.equalTo(profileImageView).offset(-2)
        }
        
        followButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(65)
            make.height.equalTo(30)
        }
    }
    
    private func setupActions() {
        followButton.addTarget(self, action: #selector(followButtonTapped(_:)), for: .touchUpInside)
    }
    
    // MARK: - Functions
    
    func setState(_ state: FollowState) {
        currentState = state
        followButton.setTitle(state.title, for: .normal)
        
        switch state {
        case .follow:
            followButton.backgroundColor = .primary
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor.primary.cgColor
            followButton.setTitleColor(.black, for: .normal)
            
        case .pending:
            followButton.backgroundColor = .white
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor.black.cgColor
            followButton.setTitleColor(.black, for: .normal)
            
        case .success:
            followButton.backgroundColor = .white
            followButton.layer.borderWidth = 0
            followButton.setTitleColor(.black, for: .normal)
        }
    }
    
    @objc private func followButtonTapped(_ sender: UIButton) {
        guard currentState != .success else { return }
        
        switch currentState {
        case .follow:
            setState(.pending)
            followStateChanged?(friendID, .pending)
        case .pending:
            setState(.follow)
            followStateChanged?(friendID, .follow)
        case .success:
            break
        }
        
        followButton.isEnabled = false
    }
    
    func configure(with friend: ContactFriend) {
        friendID = friend.friendID
        nameLabel.text = friend.name
        accountLabel.text = friend.accountID
        
        if let imageUrlString = friend.profileImage,
           let imageUrl = URL(string: imageUrlString) {
            let task = URLSession.shared.dataTask(with: imageUrl)
            { [weak self] data, response, error in
                guard let self = self,
                      let data = data,
                      let image = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    UIView.transition(with: self.profileImageView,
                                    duration: 0.3,
                                    options: .transitionCrossDissolve) {
                        self.profileImageView.image = image
                    }
                }
            }
            task.resume()
        } else {
            profileImageView.image = UIImage(named: "default_profile")
        }
    }
}

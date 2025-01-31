//
//  FollowView.swift
//  iOS_Wegg
//
//  Created by KKM on 1/31/25.
//

import UIKit
import SnapKit
import Then

class NotiFollowView: UIView {

    private let containerView = UIView()
    
    private let profileStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = -8
        $0.alignment = .center
    }

    private let firstProfileImageView = UIImageView().then {
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }

    private let secondProfileImageView = UIImageView().then {
        $0.backgroundColor = .darkGray
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }

    private let followLabel = UILabel().then {
        $0.text = "sojin1108님 외 3명"
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .black
    }

    private let indicatorView = UIView().then {
        $0.backgroundColor = .primary
        $0.layer.cornerRadius = 3
    }

    private let forwardButton = UIButton().then {
        $0.setImage(UIImage(named: "forwardButton"), for: .normal)
        $0.backgroundColor = .clear
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear

        profileStackView.addArrangedSubview(firstProfileImageView)
        profileStackView.addArrangedSubview(secondProfileImageView)
        
        containerView.addSubview(profileStackView)
        containerView.addSubview(followLabel)
        containerView.addSubview(indicatorView)
        containerView.addSubview(forwardButton)
        
        addSubview(containerView)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalTo(forwardButton.snp.leading).offset(-8)
        }

        firstProfileImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        secondProfileImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        profileStackView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        followLabel.snp.makeConstraints {
            $0.leading.equalTo(profileStackView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints {
            $0.size.equalTo(6)
            $0.leading.equalTo(followLabel.snp.trailing).offset(6)
            $0.centerY.equalToSuperview()
        }
        
        // 오른쪽에 배치
        forwardButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setupActions() {
        forwardButton.addTarget(self, action: #selector(followTapped), for: .touchUpInside)
    }

    @objc private func followTapped() {
        print("FollowView tapped")
    }
}

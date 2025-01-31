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

    // 프로필 이미지 그룹
    private let profileContainerView = UIView()
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

    // 팔로우 라벨 그룹
    private let labelContainerView = UIView()
    private let followRequestLabel = UILabel().then {
        $0.text = "팔로우 요청"
        $0.font = UIFont(name: "NotoSansKR-Regular", size: 15)
        $0.textColor = .black
    }
    private let followLabel = UILabel().then {
        $0.text = "sojin1108님 외 3명"
        $0.font = UIFont(name: "NotoSansKR-Regular", size: 13)
        $0.textColor = UIColor(red: 0.842, green: 0.842, blue: 0.842, alpha: 1)
    }

    // 버튼 그룹
    private let buttonContainerView = UIView()
    private let indicatorView = UIImageView().then {
        $0.image = UIImage(named: "newFollow")
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
    }
    private let forwardButton = UIButton().then {
        $0.setImage(UIImage(named: "forwardButton"), for: .normal)
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
    }
    
    weak var viewController: UIViewController?

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

        // 프로필 이미지 그룹
        profileContainerView.addSubview(firstProfileImageView)
        profileContainerView.addSubview(secondProfileImageView)
        
        // 팔로우 라벨 그룹
        labelContainerView.addSubview(followRequestLabel)
        labelContainerView.addSubview(followLabel)
        
        // 버튼 그룹
        buttonContainerView.addSubview(indicatorView)
        buttonContainerView.addSubview(forwardButton)
        
        // 전체 뷰에 추가
        addSubview(profileContainerView)
        addSubview(labelContainerView)
        addSubview(buttonContainerView)
    }
    
    private func setupConstraints() {
        // 프로필 이미지 그룹
        profileContainerView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.size.equalTo(40)
        }
        
        firstProfileImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        secondProfileImageView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().offset(-6)
            $0.size.equalTo(24)
        }
        
        // zIndex 조정 (firstProfileImageView가 위로 올라오도록 설정)
        profileContainerView.bringSubviewToFront(firstProfileImageView)

        // 팔로우 라벨 그룹
        labelContainerView.snp.makeConstraints {
            $0.leading.equalTo(profileContainerView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        followRequestLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        followLabel.snp.makeConstraints {
            $0.top.equalTo(followRequestLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        // 버튼 그룹
        buttonContainerView.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.width.equalTo(24) // 버튼과 indicator의 너비
            $0.height.equalTo(16) // 버튼 높이
        }
        
        indicatorView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.size.equalTo(10)
        }
        
        forwardButton.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.width.equalTo(8)
            $0.height.equalTo(16)
        }
    }
    
    private func setupActions() {
        forwardButton.addTarget(self, action: #selector(followTapped), for: .touchUpInside)
    }

    @objc private func followTapped() {
        print("FollowView tapped")
        let followVC = FollowViewController()
        viewController?.navigationController?.pushViewController(followVC, animated: true)
    }
}

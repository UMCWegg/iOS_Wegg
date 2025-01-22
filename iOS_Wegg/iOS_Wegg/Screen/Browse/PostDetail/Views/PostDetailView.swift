//
//  PostDetail.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/21/25.
//

import UIKit

class PostDetailView: UIView {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 배경색 노란색으로 설정
        self.backgroundColor = UIColor.customColor(.secondary)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    private let postImageSize: CGFloat = 43 // 유지보수를 위한 상수 정의
    
    private let profileImageView: UIImageView = {
        let profile = UIImageView()
        profile.contentMode = .scaleAspectFit
        profile.clipsToBounds = true
        profile.layer.cornerRadius = 15
        
       return profile
    }()
    private let nicknameLabel: UILabel = {
        let nickname = UILabel()
        nickname.font = UIFont.notoSans(.medium, size: 14)
        nickname.textColor = .white
        return nickname
    }()
    private let postTimeLabel = UILabel()
    
    private let space = 23
    // 게시물 상세 화면 뒷배경
    private let postImageView: UIImageView = {
        let postImage = UIImageView()
        postImage.contentMode = .scaleAspectFill
        postImage.clipsToBounds = true
        postImage.layer.cornerRadius = 15
        return postImage
    }()
    
    // 게시물 댓글창 텍스트 필드
    private let postComments: UITextField = {
        let postComments = UITextField()
        postComments.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        postComments.textColor = UIColor.black
        postComments.clipsToBounds = true
        postComments.layer.borderColor = UIColor.white.cgColor
        postComments.layer.borderWidth = 1
        postComments.layer.cornerRadius = 10
        return postComments
    }()
    
    /// 프로필, 닉네임, 시간을 묶을 사용자 정보 StackView
    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews:
        [
            profileImageView, nicknameLabel, postTimeLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    // MARK: - Methods
    
    /// UI 구성 요소 추가
    private func setupView() {
        [
            postImageView,
            userInfoStackView,
            postComments
        ].forEach {self.addSubview($0)}
    }
    /// UI 제약 조건 설정
    private func setupConstraints() {
        userInfoStackView.snp.makeConstraints {
            $0.top.equalTo(postImageView.snp.top).offset(26)
            $0.left.equalToSuperview().offset(space)
            $0.right.equalToSuperview().inset(space)
        }
        
        // 프로필 이미지 크기 설정
            profileImageView.snp.makeConstraints {
                $0.width.height.equalTo(postImageSize) // postImageSize 상수를 사용
            }
        
        postImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(46)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(postImageView.snp.width)
        }
        postComments.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(51)
            $0.left.equalToSuperview().offset(space)
            $0.right.equalToSuperview().inset(space)
        }
    }
    /// 상세 페이지 데이터 설정
    func configure(with detail: PostDetail) {
        // 프로필 이미지 설정
        profileImageView.image = UIImage(named: detail.profileImage)
        
        // 닉네임 설정
        nicknameLabel.text = detail.nickName
        
        // 게시물 이미지 설정 (첫 번째 이미지만 표시, 없으면 placeholder 사용)
        postImageView.image = UIImage(named: detail.postImages.first ?? "placeholder")
        
        // 게시 시간 레이블 설정 (formattedDate 메서드로 날짜 형식 변환)
        postTimeLabel.text = "Posted: \(formattedDate(detail.postTime))"
        
    }
    /// 시간 설정
    private func formattedDate(_ date: Date) -> String {
        // DateFormatter 초기화
        let formatter = DateFormatter()
        
        // 날짜 스타일 설정 (예: "Jan 20, 2025")
        formatter.dateStyle = .medium
        
        // 시간 스타일 설정 (예: "2:34 PM")
        formatter.timeStyle = .short
        
        // Date 객체를 문자열로 변환
        return formatter.string(from: date)
    }
}

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
    private let space: CGFloat = 23 // 레이아웃 기본 여백
    
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
    
    private let postTimeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.notoSans(.medium, size: 14)
        timeLabel.textColor = .lightGray
        return timeLabel
    }()
    
    // 게시물 상세 화면 뒷배경
    private let postImageView: UIImageView = {
        let postImage = UIImageView()
        postImage.contentMode = .scaleAspectFill
        postImage.clipsToBounds = true
        postImage.layer.cornerRadius = 15
        return postImage
    }()
    
    /// 댓글이 게시된 뷰도 따로있기에 댓글 입력창을 텍스트 필드가 아닌 버튼으로 설정함
    private let commentButton: UIButton = {
        let button = UIButton()

        // 버튼 구성
        var config = UIButton.Configuration.plain()
        config.title = "댓글을 입력하세요..."
        config.baseForegroundColor = .white // 텍스트 색상
        config.background.cornerRadius = 15
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 10, leading: 16, bottom: 10, trailing: 16
        ) // 내부 여백

        // 텍스트 왼쪽 정렬
        button.contentHorizontalAlignment = .left

        // 텍스트 폰트 설정
        button.titleLabel?.font = UIFont.notoSans(.regular, size: 15)
        button.configuration = config

        // 테두리 설정
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 15

        return button
    }()
    
    /// 이모티콘 버튼
    private let emojiButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "emoji"), for: .normal)
        button.tintColor = .white
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    /// 댓글 입력과 이모티콘 버튼을 묶는 StackView
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [commentButton, emojiButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill // 내부 뷰가 채워지도록 설정
        stackView.alignment = .fill // 높이를 스택뷰에 맞게 설정
        return stackView
    }()
    
    /// 프로필, 닉네임, 시간을 묶을 사용자 정보 StackView
    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            profileImageView,
            nicknameLabel,
            postTimeLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    // MARK: - Methods
    
    /// UI 구성 요소 추가
    private func setupView() {
        [
            postImageView,
            userInfoStackView,
            buttonStackView
        ].forEach {self.addSubview($0)}
    }
    
    /// UI 제약 조건 설정
    private func setupConstraints() {
        // 유저 정보 스택뷰
        userInfoStackView.snp.makeConstraints {
            $0.top.equalTo(postImageView.snp.top).offset(26)
            $0.left.equalToSuperview().offset(space)
            $0.right.equalToSuperview().inset(space)
        }
        
        // 스택뷰 내부 제약조건 추가 설정
        postTimeLabel.snp.makeConstraints {
               $0.trailing.lessThanOrEqualTo(userInfoStackView.snp.trailing)
           }
        
        // 프로필 이미지 크기 설정
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(postImageSize) // postImageSize 상수를 사용
        }
        
        postImageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.7) // 상대적인 크기 설정 화면 비율의 70%
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(postImageView.snp.bottom).offset(21)
            $0.left.equalToSuperview().offset(space)
            $0.right.equalToSuperview().inset(space)
            $0.height.equalTo(44)
        }
        
        emojiButton.snp.makeConstraints {
            $0.width.equalTo(buttonStackView.snp.height) // 버튼 크기 비례 설정
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
        postTimeLabel.text = "게시시간:  \(formattedDate(detail.postTime))"
        
    }
    /// 시간 설정
    private func formattedDate(_ date: Date) -> String {
        // DateFormatter 초기화
        return DateFormatterUtility.formattedDate(date)
    }
}

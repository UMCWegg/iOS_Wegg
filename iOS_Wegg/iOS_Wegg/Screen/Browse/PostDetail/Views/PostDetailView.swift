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
    
    /// 팝업창 프로퍼티
    lazy var emojiPopupView = EmojiPopupView()
    lazy var plusEmojiView = PlusEmojiView()
    
    private let postImageSize: CGFloat = 43 // 유지보수를 위한 상수 정의
    private let space: CGFloat = 23 // 레이아웃 기본 여백
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
    }
    
    private let nicknameLabel = UILabel().then {
        $0.font = UIFont.notoSans(.medium, size: 14)
        $0.textColor = .white
    }
    
    private let postTimeLabel = UILabel().then {
        $0.font = UIFont.notoSans(.medium, size: 14)
        $0.textColor = .lightGray
    }
    
    // 게시물 상세 화면 뒷배경
    private let postImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
    }
    
    /// 댓글이 게시된 뷰도 따로있기에 댓글 입력창을 텍스트 필드가 아닌 버튼으로 설정함
    lazy var commentButton = UIButton().then {
        // 버튼 구성
        var config = UIButton.Configuration.plain()
        config.title = "댓글을 입력하세요..."
        config.baseForegroundColor = .white // 텍스트 색상
        config.background.cornerRadius = 15
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 10, leading: 16, bottom: 10, trailing: 16
        ) // 내부 여백
        
        // 텍스트 왼쪽 정렬
        $0.contentHorizontalAlignment = .left
        
        // 텍스트 폰트 설정
        $0.titleLabel?.font = UIFont.notoSans(.regular, size: 15)
        $0.configuration = config
        
        // 테두리 설정
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 15
    }
    
    /// 이모티콘 버튼
    lazy var emojiButton = UIButton().then {
        $0.setImage(UIImage(named: "emoji"), for: .normal)
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }
    
    /// 댓글 입력과 이모티콘 버튼을 묶는 StackView
    private lazy var buttonStackView = UIStackView(
        arrangedSubviews: [commentButton, emojiButton]).then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill // 내부 뷰가 채워지도록 설정
        $0.alignment = .fill // 높이를 스택뷰에 맞게 설정
    }
    
    /// 프로필, 닉네임, 시간을 묶을 사용자 정보 StackView
    private lazy var userInfoStackView = UIStackView(arrangedSubviews: [
        profileImageView,
        nicknameLabel,
        postTimeLabel
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
    }
    
    // MARK: - Methods
    
    /// 이모지 팝업을 화면에 표시하는 메서드
    func showEmojiPopup() {
        // 팝업이 이미 추가되지 않은 경우에만 추가
        if emojiPopupView.superview == nil {
            addSubview(emojiPopupView) // 이모지 팝업을 현재 뷰에 추가

            // SnapKit으로 팝업의 제약 조건 설정
            emojiPopupView.snp.makeConstraints {
                $0.centerX.equalTo(emojiButton) // 이모지 버튼과 수평으로 정렬
                $0.bottom.equalTo(emojiButton.snp.top).offset(-34) // 버튼 위로 약간 띄움
                $0.width.equalTo(80) // 팝업의 너비 설정
                $0.height.equalTo(250) // 팝업의 높이 설정
            }

            // 이모지 선택 시 호출되는 클로저 정의
            emojiPopupView.emojiSelected = { [weak self] selectedEmoji in
                print("Selected Emoji: \(selectedEmoji)") // 선택된 이모지 출력
                self?.hideEmojiPopup() // 선택 후 팝업 숨기기
            }
        }

        // 팝업이 부드럽게 나타나는 애니메이션
        UIView.animate(withDuration: 0.3) {
            self.emojiPopupView.alpha = 1 // 팝업의 투명도를 1로 설정하여 표시
        }
    }
    
    /// 이모지 팝업을 화면에서 숨기는 메서드
    func hideEmojiPopup() {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.emojiPopupView.alpha = 0 // 팝업의 투명도를 0으로 설정하여 숨김
            },
            completion: { _ in
                self.emojiPopupView.removeFromSuperview() // 애니메이션 완료 후 팝업 제거
            }
        )
    }
    
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
            $0.height.equalToSuperview().multipliedBy(0.75) // 상대적인 크기 설정 화면 비율의 75%
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
    func configure(with detail: PostDetailModel) {
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

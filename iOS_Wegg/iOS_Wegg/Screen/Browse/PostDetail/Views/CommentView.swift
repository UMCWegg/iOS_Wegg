//
//  CommentView.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/1/25.
//

import UIKit
import SnapKit

class CommentView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    /// 댓글 리스트 상단에 이모지를 표시하는 헤더 뷰
    private lazy var headerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    /// 이모지를 가로 스크롤할 수 있는 스크롤 뷰
    private lazy var emojiScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceHorizontal = true
    }
    
    /// 여러 개의 이모지를 가로로 배치할 스택 뷰
    private lazy var emojiStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 15
        $0.distribution = .equalSpacing
    }
    
    /// 헤더와 테이블 뷰를 구분하는 구분선
    private let headerSeparator = UIView().then {
        $0.backgroundColor = .systemGray3
    }
    
    /// 댓글 입력 필드와 버튼을 감싸는 컨테이너 뷰
    private lazy var textFieldContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 25
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray3.cgColor
        $0.layer.masksToBounds = true
    }
    
    /// 댓글 입력 필드
    lazy var commentTextField = UITextField().then {
        $0.placeholder = "댓글을 입력하세요 ..."
        $0.font = UIFont.notoSans(.regular, size: 14)
        $0.isUserInteractionEnabled = true
        $0.borderStyle = .none
        $0.backgroundColor = .clear
    }
    
    /// 댓글 등록 버튼
    lazy var submitButton = UIButton().then {
        $0.setImage(UIImage(named: "submit_icon"), for: .normal)
        $0.tintColor = .systemBlue
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    /// 댓글 리스트를 표시할 테이블 뷰
    lazy var tableView = UITableView().then {
        $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        $0.separatorStyle = .none
    }
    
    /// 댓글 입력 필드와 리스트를 구분하는 구분선
    let separator = UIView().then {
        $0.backgroundColor = .systemGray2
    }
    
    // MARK: - Setup Methods
    
    /// UI 요소들을 추가하는 메서드
    private func setupView() {
        backgroundColor = .white
        [headerView,
         headerSeparator,
         tableView,
         separator,
         textFieldContainerView
        ].forEach { self.addSubview($0) }
        
        // hearderView에 -> 이모지 스크롤뷰 -> 이모지 가로 스택뷰 추가
        headerView.addSubview(emojiScrollView)
        emojiScrollView.addSubview(emojiStackView)
        
        // 텍스트필드 컨테이너에 댓글과 보내기버튼 추가
        textFieldContainerView.addSubview(commentTextField)
        textFieldContainerView.addSubview(submitButton)
    }
    
    /// Header 제약: (이모지 스크롤 + 이모지 가로스택) 제약 조건 설정
    private func setupHeaderConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(55)
        }
        
        emojiScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        
        emojiStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        headerSeparator.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(headerView.snp.bottom).offset(8)
        }
    }
    
    /// UI 제약:  댓글창 테이블뷰, (텍스트 + 전송버튼) 컨테이너뷰 제약조건
    private func setupConstraints() {
        setupHeaderConstraints() 
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(headerSeparator.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(textFieldContainerView.snp.top).offset(-16)
        }
        
        textFieldContainerView.snp.makeConstraints {
            // 키보드 높이에 맞게 조정
            $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        commentTextField.snp.makeConstraints {
            $0.leading.equalTo(textFieldContainerView.snp.leading).offset(16)
            $0.centerY.equalTo(textFieldContainerView)
            $0.trailing.equalTo(submitButton.snp.leading).offset(-10)
            $0.height.equalTo(40)
        }
        
        submitButton.snp.makeConstraints {
            $0.trailing.equalTo(textFieldContainerView.snp.trailing).offset(-16)
            $0.centerY.equalTo(textFieldContainerView)
            $0.width.height.equalTo(24)
        }
        
        separator.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.bottom.equalTo(textFieldContainerView.snp.top).offset(-12)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Emoji Handling Methods
    
    /// 이모지 이미지를 업데이트하는 메서드
    func updateEmojiImages(with imageNames: [String]) {
        clearEmojiStackView()
        addEmojiImages(imageNames)
    }
    
    /// 스택뷰에서 모든 이모지 제거
    private func clearEmojiStackView() {
        emojiStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    /// 전달받은 이모지 이미지 배열을 스택뷰에 추가
    private func addEmojiImages(_ imageNames: [String]) {
        imageNames.forEach { imageName in
            let imageView = createEmojiImageView(named: imageName)
            emojiStackView.addArrangedSubview(imageView)
        }
    }
    
    /// 개별 이모지 이미지를 생성하여 반환
    private func createEmojiImageView(named imageName: String) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { $0.width.height.equalTo(34) }
        return imageView
    }
}

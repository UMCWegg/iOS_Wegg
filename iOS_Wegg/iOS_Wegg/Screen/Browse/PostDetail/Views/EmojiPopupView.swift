//
//  EmojiPopupView.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/25/25.
//

import UIKit

class EmojiPopupView: UIView {
    
    // 이모지 선택 시 호출되는 클로저
    var emojiSelected: ((String) -> Void)? // 선택된 이모지를 전달하는 클로저
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView() // 뷰 구성
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    /// 뷰를 설정하는 메서드
    private func setupView() {
        // 뷰의 배경 색상 및 스타일 설정
        backgroundColor = .white
        layer.cornerRadius = 16 // 둥근 모서리
        layer.shadowColor = UIColor.black.cgColor // 그림자 색상
        layer.shadowOpacity = 0.1 // 그림자 투명도
        layer.shadowOffset = CGSize(width: 0, height: 4) // 그림자 위치
        layer.shadowRadius = 8 // 그림자 퍼짐 정도
        
        // 이모지 이미지 배열
        let emojiImages = ["smile.png", "thumbs_up.png", "heart.png", "plus.png"]
        
        // 스택 뷰 생성 및 설정 (이모지 버튼을 세로로 배치)
        let stackView = UIStackView()
        stackView.axis = .vertical // 세로 방향 정렬
        stackView.spacing = 8 // 버튼 간의 간격
        stackView.alignment = .center // 버튼 정렬: 중앙
        stackView.distribution = .fillEqually // 버튼 크기를 동일하게 분배
        
        // 이모지 버튼 생성 및 스택 뷰에 추가
        for imageName in emojiImages {
            let button = UIButton(type: .system) // 시스템 타입 버튼 생성
            button.setImage(UIImage(
                named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal) // 원본 이미지 렌더링
            button.imageView?.contentMode = .scaleAspectFill // 이미지 크기 설정
            button.addTarget(
                self,
                action: #selector(emojiTapped(_:)),
                for: .touchUpInside) // 클릭 이벤트 연결
            stackView.addArrangedSubview(button) // 스택 뷰에 버튼 추가
        }
        
        // 스택 뷰를 현재 뷰에 추가
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8) // 스택 뷰의 여백 설정
        }
    }

    /// 이모지 버튼 클릭 시 호출되는 메서드
    @objc private func emojiTapped(_ sender: UIButton) {
        // 클릭된 버튼의 이미지를 가져오기
        guard let emojiImage = sender.imageView?.image else { return }
        // 선택된 이모지의 ID 또는 이름을 클로저를 통해 전달
        emojiSelected?(emojiImage.accessibilityIdentifier ?? "")
    }
}

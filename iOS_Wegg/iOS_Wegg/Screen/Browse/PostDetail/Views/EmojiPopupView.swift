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
        // 팝업 뷰의 배경 투명 처리
        backgroundColor = .clear
        
        // 이모지 이미지 배열
        let emojiImages = ["smile.png", "thumbs_up.png", "heart.png", "plus.png"]
        
        // 스택 뷰 생성 및 설정
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10 // 버튼 간의 간격
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        // 각 이모지 버튼에 배경 뷰 추가
        for imageName in emojiImages {
            // 동그란 배경 뷰 생성
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.7) // 투명한 배경
            backgroundView.layer.cornerRadius = 24 // 동그란 모서리 (너비/2)
            backgroundView.clipsToBounds = true
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            
            // 버튼 생성
            let button = UIButton(type: .system)
            button.setImage(
                UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal),
                for: .normal
            )
            button.imageView?.contentMode = .scaleAspectFit
            button.addTarget(self, action: #selector(emojiTapped(_:)), for: .touchUpInside)
            
            // 배경 뷰에 버튼 추가
            backgroundView.addSubview(button)
            button.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.height.equalTo(32) // 버튼 크기
            }
            
            // 배경 뷰 크기 설정
            backgroundView.snp.makeConstraints {
                $0.width.height.equalTo(48) // 배경 크기
            }
            
            // 스택 뷰에 배경 뷰 추가
            stackView.addArrangedSubview(backgroundView)
        }
        
        // 스택 뷰를 팝업 뷰에 추가
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
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

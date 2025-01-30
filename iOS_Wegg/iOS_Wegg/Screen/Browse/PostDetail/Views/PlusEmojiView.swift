//
//  PlusEmojiView.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/28/25.
//

import UIKit

class PlusEmojiView: UIView {
    
    // 선택된 이모지를 전달하는 클로저
    var emojiSelected: ((String) -> Void)?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView() // 뷰 구성
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
}

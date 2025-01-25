//
//  NaverLoginButton.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.17.
//

import UIKit

class LoginButton: UIButton {
    
    // MARK: - Init
    
    init(title: String, backgroundColor: UIColor, image: UIImage? = nil) {
        super.init(frame: .zero)
        setupButton(title: title, backgroundColor: backgroundColor)
        if let image = image {
            setupImageView(image: image)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let contentStack = UIStackView().then {
        $0.spacing = 10
        $0.alignment = .center
    }
    
    // MARK: - Setup
    
    private func setupButton(title: String, backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
        layer.cornerRadius = 26.5
        titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 20)
        
        setTitleColor((backgroundColor == .black ||
                       backgroundColor == UIColor(named: "YellowSecondary"))
                       ? .white : .black, for: .normal)
        
        heightAnchor.constraint(equalToConstant: 53).isActive = true
        widthAnchor.constraint(equalToConstant: 348).isActive = true
    }
    
    private func setupImageView(image: UIImage) {
        addSubview(iconImageView)
        iconImageView.image = image
        
        if let titleLabel = titleLabel {
            [iconImageView, titleLabel].forEach {
                contentStack.addArrangedSubview($0)
            }
        }
    }
}

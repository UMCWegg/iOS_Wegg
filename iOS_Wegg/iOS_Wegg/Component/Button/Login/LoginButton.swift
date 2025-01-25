//
//  NaverLoginButton.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.17.
//

import UIKit

class LoginButton: UIButton {
    
    // MARK: - Style
    
    enum Style {
        case textOnly
        case iconText
    }
    
    // MARK: - Init
    
    init(style: Style, title: String, backgroundColor: UIColor, image: UIImage? = nil) {
        super.init(frame: .zero)
        setupCommon(backgroundColor: backgroundColor)
        
        switch style {
        case .textOnly:
            setupTextOnly(title: title)
        case .iconText:
            guard let image = image else { return }
            setupIconText(title: title, image: image)
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
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .fill
    }
    
    // MARK: - Setup
    
    private func setupCommon(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 26.5
        heightAnchor.constraint(equalToConstant: 53).isActive = true
        widthAnchor.constraint(equalToConstant: 348).isActive = true
    }
    
    private func setupTextOnly(title: String) {
        titleSetup(title: title)
    }
    
    private func setupIconText(title: String, image: UIImage) {
        guard let titleLabel = titleLabel else { return }
        
        iconImageView.image = image
        addSubview(contentStack)
        
        contentStack.addArrangedSubview(iconImageView)
        contentStack.addArrangedSubview(titleLabel)
        
        contentStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        
        titleSetup(title: title)
    }
    
    private func titleSetup(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.notoSans(.medium, size: 17)
        
        setTitleColor((backgroundColor == .black ||
                       backgroundColor == UIColor.customColor(.secondary))
                       ? .white : .black, for: .normal)
    }
}

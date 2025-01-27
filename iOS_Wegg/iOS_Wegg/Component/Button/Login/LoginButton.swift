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
        $0.clipsToBounds = false
    }
    
    private let contentStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
    }
    
    // MARK: - Setup
    
    private func setupCommon(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 26.5
        heightAnchor.constraint(equalToConstant: 53).isActive = true
        widthAnchor.constraint(equalToConstant: 348).isActive = true
    }
    
    private func setupTextOnly(title: String) {
        let label = titleSetup(title: title)
        setTitle(label.text, for: .normal)
        titleLabel?.font = label.font
        titleLabel?.textColor = label.textColor
    }
    
    private func setupIconText(title: String, image: UIImage) {
        let textLabel = titleSetup(title: title)
        iconImageView.image = image
        
        addSubview(contentStack)
        contentStack.addArrangedSubview(iconImageView)
        contentStack.addArrangedSubview(textLabel)
        
        contentStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(40)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        
        textLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
    }
    
    private func titleSetup(title: String) -> UILabel {
        return UILabel().then {
            $0.text = title
            $0.font = UIFont.notoSans(.medium, size: 17)
            $0.textColor = (backgroundColor == .black ||
                           backgroundColor == UIColor.customColor(.secondary))
                           ? .white : .black
        }
    }
}

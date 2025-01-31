//
//  GetAlertPermissionView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.31.
//

import UIKit

class GetAlertPermissionView: UIView {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradientLayer = imageContainerView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = imageContainerView.bounds
        }
    }
    
    // MARK: - Properties
    
    private let mainLabel = LoginLabel(title: "알림을 활성화하여\n나의 공부 인증 시간을 알림으로 받아요!", type: .main)
    
    private let subLabel = LoginLabel(title: "공부 인증시간을 알려주는 알림을 제외하면\n모든 알림은 무음이에요.", type: .sub)
    
    private let infoLabel = UILabel().then {
        $0.text = "wegg에서 인증 시간을 알 수 있는 유일한 방법은,\n알림을 활성화 하는 것 뿐이에요"
        $0.font = UIFont.LoginFont.label
        $0.textColor = UIColor(red: 1, green: 0.77, blue: 0.14, alpha: 1)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let alertPhoneImage = UIImageView().then {
        $0.image = UIImage(named: "alert_phone")
    }
    
    private let imageContainerView = UIView().then {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor(white: 1.0, alpha: 0.8).cgColor,
            UIColor.white.cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        $0.layer.addSublayer(gradientLayer)
    }
    
    let nextButton = LoginButton(
        style: .textOnly,
        title: "다음",
        backgroundColor: .primary
    )
    
    // MARK: - Setup
    
    private func setupViews() {
        [
            mainLabel,
            subLabel,
            infoLabel,
            imageContainerView,
            nextButton
        ].forEach { addSubview($0) }
        
        imageContainerView.addSubview(alertPhoneImage)
    }
    
    private func setupConstraints() {
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(108)
            make.leading.equalToSuperview().offset(17)
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(8)
            make.leading.equalTo(mainLabel)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(42)
            make.centerX.equalToSuperview()
        }
        
        imageContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(infoLabel.snp.bottom).offset(18)
            make.width.equalTo(alertPhoneImage)
        }
        
        alertPhoneImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(264)
            make.height.equalTo(468)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
        
    }

}

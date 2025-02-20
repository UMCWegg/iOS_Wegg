//
//  PlaceVerificationInfoView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/14/25.
//

import UIKit

class PlaceVerificationInfoView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var yellowLogoIcon = makeImageView("yellow_wegg_icon").then {
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(17)
        }
    }
    
    private lazy var titleLabel = makeLabel(
        font: UIFont.notoSans(.bold, size: 16),
        color: .primary
    )
    
    private lazy var subtitleLabel = makeLabel(
        font: UIFont.notoSans(.medium, size: 11),
        color: .black
    )
    
    private lazy var titleStackView = makeStackView(spacing: 5, axis: .horizontal)
    
    private lazy var verificationInfoView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 25
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.secondary.cgColor
    }
    
    private lazy var verificationLogoImageView = makeImageView("verification_logo").then {
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(65)
        }
    }
    
    @MainActor
    public func setLabel(title: String, subTitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subTitle
        layoutIfNeeded()
    }
    
    private func makeButton(
        _ title: String,
        backgroundColor: UIColor = .primary,
        fontColor: UIColor = .secondary
    ) -> UIButton {
        return UIButton().then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(fontColor, for: .normal)
            $0.titleLabel?.font = .notoSans(.medium, size: 16)
            $0.backgroundColor = backgroundColor
        }
    }
    
    private func makeImageView(
        _ imageName: String,
        contentMode: UIView.ContentMode = .scaleAspectFill
    ) -> UIImageView {
        return UIImageView().then {
            $0.image = UIImage(named: imageName)
            $0.contentMode = contentMode
        }
    }
    
    func makeLabel(
        font: UIFont?,
        color: UIColor
    ) -> UILabel {
        let label = UILabel()
        label.font = font ?? UIFont.systemFont(ofSize: 19, weight: .medium)
        label.textColor = color
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }
    
    func makeStackView(
        spacing: CGFloat,
        axis: NSLayoutConstraint.Axis
    ) -> UIStackView {
        let stack = UIStackView()
        stack.axis = axis
        stack.spacing = spacing
        stack.distribution = .fill
        return stack
    }

    private func setupView() {
        addComponents()
        constraints()
    }
    
    private func addComponents() {
        [verificationInfoView, verificationLogoImageView].forEach(addSubview)
        [yellowLogoIcon, titleLabel].forEach(titleStackView.addArrangedSubview)
        
        verificationInfoView.addSubview(titleStackView)
        verificationInfoView.addSubview(subtitleLabel)
    }
    
    private func constraints() {
        verificationInfoView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(77)
        }
        titleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(7)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        verificationLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(verificationInfoView.snp.bottom).offset(10)
            make.centerX.equalTo(verificationInfoView.snp.centerX)
        }
    }
}

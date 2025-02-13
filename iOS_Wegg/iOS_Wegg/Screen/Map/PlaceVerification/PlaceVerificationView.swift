//
//  PlaceVerificationOverlayView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/13/25.
//

import UIKit
import Then

class PlaceVerificationOverlayView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// hitTest(_:with:)
    /// - 터치 이벤트를 처리할 최종 뷰 결정
    /// - 지도 위에서 제스처 필요한 버튼 추가
    /// - Returns: 터치 이벤트를 처리할 UIView(없을 경우 nil 반한)
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
    
    /// PlaceVerificationOverlayView의 기본 레이아웃 설정(전체 화면)
    func setupOverlayConstraints(in parentView: UIView) {
        parentView.addSubview(self)
        snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Property
    
    private lazy var verificationButton = makeButton("인증하기").then {
        $0.layer.cornerRadius = 26
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.secondary.cgColor
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
    
    private lazy var verificationLogoImageView = createImageView(
        imageName: "verification_logo"
    ).then {
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(65)
        }
    }
    
    // MARK: - Functions
    
    public func configuration(title: String, subTitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subTitle
    }
    
    // MARK: Utility Functions
    
    /// UIImageView를 제작하는 함수
    ///
    /// - Parameters:
    ///     - imageName: 사용할 이미지 이름
    ///     - contentMode: 이미지의 ContentMode. 기본값은 `scaleAspectFit`
    ///     - isUserInteractionEnabled: 제스처 활성화 여부. 기본값은 `true`
    /// - Returns: 설정된 `UIImageView` 인스턴스 반환
    private func createImageView(
        imageName: String,
        contentMode: UIView.ContentMode = .scaleAspectFill,
        isUserInteractionEnabled: Bool = true
    ) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = contentMode
        imageView.isUserInteractionEnabled = isUserInteractionEnabled
        return imageView
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
    
}

private extension PlaceVerificationOverlayView {
    func setupView() {
        addComponenets()
        constraints()
    }
    
    func addComponenets() {
        [
            verificationInfoView,
            verificationButton,
            verificationLogoImageView
        ].forEach(addSubview)
        
        [yellowLogoIcon, titleLabel].forEach(titleStackView.addArrangedSubview)
        
        verificationInfoView.addSubview(titleStackView)
        verificationInfoView.addSubview(subtitleLabel)
    }
    
    func constraints() {
        verificationInfoView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(77)
        }
        
        verificationLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(verificationInfoView.snp.bottom).offset(10)
            make.centerX.equalTo(verificationInfoView.snp.centerX)
        }
        
        verificationButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().inset(40)
            make.height.equalTo(61)
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
    }
}

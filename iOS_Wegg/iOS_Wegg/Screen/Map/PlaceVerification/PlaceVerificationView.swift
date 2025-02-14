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
    
    lazy var placeVerificationInfoView = PlaceVerificationInfoView().then {
        $0.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(140)
        }
    }
    
    private lazy var verificationButton = makeButton("인증하기").then {
        $0.layer.cornerRadius = 26
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.secondary.cgColor
    }
    
    // MARK: - Functions
    
    public func configuration(title: String, subTitle: String) {
        placeVerificationInfoView.setLabel(title: title, subTitle: subTitle)
    }
    
    // MARK: Utility Functions
    
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
    
}

private extension PlaceVerificationOverlayView {
    func setupView() {
        addComponenets()
        constraints()
    }
    
    func addComponenets() {
        addSubview(placeVerificationInfoView)
        addSubview(verificationButton)
    }
    
    func constraints() {
        verificationButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().inset(40)
            make.height.equalTo(61)
        }
    }
}

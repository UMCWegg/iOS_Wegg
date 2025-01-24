//
//  MapView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/24/25.
//

import UIKit
import SnapKit
import Then

class MapOverlayView: UIView {
    
    var onLocationImageButtonTap: (() -> Void)?
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// MapOverlayView의 기본 레이아웃 설정(전체 화면)
    func setupOverlayConstraints(in parentView: UIView) {
        parentView.addSubview(self)
        snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// hitTest(_:with:) - 터치 이벤트를 처리할 최종 뷰 결정
    /// - Parameters:
    ///     - porint: 이벤트가 발생한 지점(뷰 좌표계 기준)
    ///     - event: 현재 발생한 UIEvent(예: 터치 이벤트)
    /// - Returns: 터치 이벤트를 처리할 UIView(없을 경우 nil 반한)
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 지도 영역에서는 터치 이벤트를 처리
        if let map = currentLocationImageButton.hitTest(
            convert(point, to: currentLocationImageButton),
            with: event
        ) {
            return map
        }
        // 지도 외의 터치 이벤트는 nil을 반환
        return nil
    }
    
    @objc private func handleLocationImageButton() {
        guard let onLocationImageButtonTap else {
            print("onLocationImageButtonTap is nil")
            return
        }
        onLocationImageButtonTap()
    }
    
    // MARK: - Property
    
    private let currentLocationImageButton = UIImageView().then {
        $0.image = UIImage(named: "current_position")
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = true
    }
    
}

// MARK: - 초기 설정 함수

private extension MapOverlayView {
    func setup() {
        addComponents()
        constraints()
        setupGestures()
    }
    
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleLocationImageButton)
        )
        currentLocationImageButton.addGestureRecognizer(tapGesture)
    }
    
    func addComponents() {
        [currentLocationImageButton].forEach {
            addSubview($0)
        }
    }
    
    func constraints() {
        currentLocationImageButton.snp.makeConstraints { make in
            make.leading.equalTo(327)
            make.trailing.equalTo(-21)
            make.bottom.equalTo(-21)
        }
    }
}

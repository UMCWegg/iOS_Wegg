//
//  MapView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/24/25.
//

import UIKit
import SnapKit
import Then

private struct OverlayLayout {
    struct CurrentLocation {
        static let leadingOffset: CGFloat = 327
        static let trailingOffset: CGFloat = -21
        static let bottomOffset: CGFloat = -21
    }
    struct PlaceSearch {
        static let leadingOffset: CGFloat = 327
        static let trailingOffset: CGFloat = -21
        static let topOffset: CGFloat = 10
    }
}

class MapOverlayView: UIView {
    weak var gestureDelegate: MapOverlayGestureDelegate?
    
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
        gestureDelegate?.didDetectTapGestureOnLocationButton()
    }
    
    // MARK: - Property
    
    private lazy var currentLocationImageButton = createImageView(
        imageName: "current_position_icon"
    )
    
    private lazy var placeSearchView = createImageView(imageName: "map_search_icon")
    
    // MARK: UI 제작하는 함수
    
    /// UIImageView를 제작하는 함수
    ///
    /// - Parameters:
    ///     - imageName: 사용할 이미지 이름
    ///     - contentMode: 이미지의 ContentMode. 기본값은 `scaleAspectFit`
    ///     - isUserInteractionEnabled: 제스처 활성화 여부. 기본값은 `true`
    /// - Returns: 설정된 `UIImageView` 인스턴스 반환
    private func createImageView(
        imageName: String,
        contentMode: UIView.ContentMode = .scaleAspectFit,
        isUserInteractionEnabled: Bool = true
    ) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = contentMode
        imageView.isUserInteractionEnabled = isUserInteractionEnabled
        return imageView
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
        [
            currentLocationImageButton,
            placeSearchView
        ].forEach {
            addSubview($0)
        }
    }
    
    func constraints() {
        placeSearchView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(
                OverlayLayout.PlaceSearch.topOffset
            )
            make.leading.equalToSuperview().offset(
                OverlayLayout.PlaceSearch.leadingOffset
            )
            make.trailing.equalToSuperview().offset(
                OverlayLayout.PlaceSearch.trailingOffset
            )
        }
        
        currentLocationImageButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(
                OverlayLayout.CurrentLocation.leadingOffset
            )
            make.trailing.equalToSuperview().offset(
                OverlayLayout.CurrentLocation.trailingOffset
            )
            make.bottom.equalToSuperview().offset(
                OverlayLayout.CurrentLocation.bottomOffset
            )
        }
    }
}

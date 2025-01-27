//
//  MapView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/24/25.
//

import UIKit
import SnapKit
import Then

/// MapOverlayViewLayout
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
    
    // MARK: - Tap Gesture
    
    /// hitTest(_:with:)
    /// - 터치 이벤트를 처리할 최종 뷰 결정
    /// - 지도 위에서 제스처 필요한 버튼 추가
    /// - Returns: 터치 이벤트를 처리할 UIView(없을 경우 nil 반한)
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 현재 위치 버튼 터치 이벤트 처리
        if let currentLocation = currentLocationImageButton.hitTest(
            convert(point, to: currentLocationImageButton),
            with: event
        ) {
            return currentLocation
        }
        
        // 장소 검색 버튼 터치 이벤트를 처리
        if let search = placeSearchButton.hitTest(
            convert(point, to: placeSearchButton),
            with: event
        ) {
            return search
        }
        
        if let hotPlaceList = hotPlaceListButton.hitTest(
            convert(point, to: hotPlaceListButton),
            with: event
        ) {
            return hotPlaceList
        }
        
        // 지도 외의 터치 이벤트는 nil을 반환
        return nil
    }
    
    @objc private func handleLocationImageButton() {
        gestureDelegate?.didDetectOnLocationButtonTapped()
    }
    
    @objc private func handlePlaceSearchButton() {
        gestureDelegate?.didPlaceSearchButtonTapped()
    }
    
    @objc private func handleHotPlaceListButton() {
        gestureDelegate?.didHotPlaceListTapped()
    }
    
    // MARK: - Property
    
    private lazy var currentLocationImageButton = createImageView(
        imageName: "current_position_icon"
    )
    
    private lazy var placeSearchButton = createImageView(imageName: "map_search_icon")
    
    private lazy var hotPlaceListButton = UIButton().then {
        var config = UIButton.Configuration.filled() // 기본 스타일 설정
        config.title = "목록 보기" // 텍스트 설정
        var textTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var updated = incoming
            updated.font = .gmarketSans(.medium, size: 15) // 커스텀 폰트 설정
            updated.foregroundColor = .secondary // 텍스트 색상 설정
            return updated
        }
        config.titleTextAttributesTransformer = textTransformer
        config.image = UIImage(named: "map_list_icon")
        config.imagePadding = 8
        config.imagePlacement = .leading
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .secondary
        
        // 버튼의 레이아웃 및 외곽선 스타일 설정
        $0.configuration = config
        $0.layer.cornerRadius = 24
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.secondary.cgColor
    }
    
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
        let locationButtonTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleLocationImageButton)
        )
        currentLocationImageButton.addGestureRecognizer(locationButtonTapGesture)
        
        let placeSearchButtonTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handlePlaceSearchButton)
        )
        placeSearchButton.addGestureRecognizer(placeSearchButtonTapGesture)
        
        // UIButton의 addTarget으로 탭 제스처 설정
        hotPlaceListButton.addTarget(
            self,
            action: #selector(handleHotPlaceListButton),
            for: .touchUpInside
        )
    }
    
    func addComponents() {
        [
            currentLocationImageButton,
            placeSearchButton,
            hotPlaceListButton
        ].forEach {
            addSubview($0)
        }
    }
    
    func constraints() {
        placeSearchButton.snp.makeConstraints { make in
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
        
        hotPlaceListButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(140)
            make.trailing.equalToSuperview().offset(-140)
            make.bottom.equalToSuperview().offset(-21)
            make.width.equalTo(100)
            make.height.equalTo(43)
        }
    }
}

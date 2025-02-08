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
        // 장소 검색 버튼 터치 이벤트를 처리
        if let search = placeSearchButton.hitTest(
            convert(point, to: placeSearchButton),
            with: event
        ) {
            return search
        }
        
        // 검색바 터치 이벤트 처리
        if let placeSearchBar = placeSearchBar.hitTest(
            convert(point, to: placeSearchBar),
            with: event
        ) {
            return placeSearchBar
        }
        
        // 현재 위치 버튼 터치 이벤트 처리
        if let currentLocation = currentLocationImageButton.hitTest(
            convert(point, to: currentLocationImageButton),
            with: event
        ) {
            return currentLocation
        }
        
        if let placeDetailBackButton = placeDetailBackButton.hitTest(
            convert(point, to: placeDetailBackButton),
            with: event
        ) {
            return placeDetailBackButton
        }
        
        // 지도 외의 터치 이벤트는 nil을 반환
        return nil
    }
    
    @objc private func handleLocationImageButton() {
        gestureDelegate?.didTapDetectOnLocationButton()
    }
    
    @objc private func handlePlaceSearchButton() {
        gestureDelegate?.didTapPlaceSearchButton()
    }
    
    @objc private func handlePlaceSearchBar() {
        gestureDelegate?.didTapPlaceSearchBar()
    }
    
    @objc private func handlePlaceDetailBackButton() {
        print("handlePlaceDetailBackButton")
    }
    
    // MARK: - Property
    
    /// `MapSearchView`에서 검색 결과 반환시 보여줄 검색바
    lazy var placeSearchBar = MapSearchBar().then {
        $0.backgroundColor = .white
        $0.isHidden = true
    }
    
    lazy var placeDetailBackButton = createImageView(imageName: "place_back_button").then {
        $0.isHidden = true
    }
    lazy var placeSearchButton = createImageView(imageName: "map_search_icon")
    private lazy var currentLocationImageButton = createImageView(
        imageName: "current_position_icon"
    )
    
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
        contentMode: UIView.ContentMode = .scaleAspectFill,
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
        
        let placeSearchBarTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handlePlaceSearchBar)
        )
        placeSearchBar.addGestureRecognizer(placeSearchBarTapGesture)
        
        let placeDetailBackButtonTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handlePlaceDetailBackButton)
        )
        placeDetailBackButton.addGestureRecognizer(placeDetailBackButtonTapGesture)
    }
    
    func addComponents() {
        [
            placeDetailBackButton,
            placeSearchButton,
            placeSearchBar,
            currentLocationImageButton
        ].forEach {
            addSubview($0)
        }
    }
    
    func constraints() {
        placeDetailBackButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(
                MapViewLayout.PlaceSearch.topOffset
            )
            make.leading.lessThanOrEqualToSuperview().offset(21)
        }
        
        placeSearchBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(
                MapViewLayout.PlaceSearch.searchBarHeight
            )
        }
        
        placeSearchButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(
                MapViewLayout.PlaceSearch.topOffset
            )
            make.leading.equalToSuperview().offset(
                MapViewLayout.PlaceSearch.leadingOffset
            )
            make.trailing.equalToSuperview().offset(
                MapViewLayout.PlaceSearch.trailingOffset
            )
        }
        
        currentLocationImageButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(
                MapViewLayout.CurrentLocation.leadingOffset
            )
            make.trailing.equalToSuperview().offset(
                MapViewLayout.CurrentLocation.trailingOffset
            )
            // 바텀 시트 높이 + Offset
            make.bottom.equalToSuperview().offset(
                -MapViewLayout.initialBottomSheetHeight + MapViewLayout.CurrentLocation.bottomOffset
            )
            make.width.height.equalTo(
                MapViewLayout.CurrentLocation.widthAndHeight
            )
        }
    }
}

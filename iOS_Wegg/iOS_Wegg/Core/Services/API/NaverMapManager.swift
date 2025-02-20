//
//  NaverMapManager.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/22/25.
//

import UIKit
import NMapsMap
import CoreLocation

/// 네이버 지도에 특화된 추가 기능 프로토콜
protocol NaverMapManagerProtocol: MapManagerProtocol {
    func setIndoorMapEnabled(_ enabled: Bool)
}

class NaverMapManager:
    NSObject,
    NaverMapManagerProtocol {
    
    private var mapView: NMFMapView?
    private var locationOverlay: NMFLocationOverlay?
    private var locationManager: CLLocationManager?
    private var tapGestureHandler: ((Coordinate) -> Void)?
    private var longTapGestureHandler: ((Coordinate) -> Void)?
    private var locationUpdateHandler: ((Coordinate?) -> Void)?
    private var currentLocation: Coordinate?
    private var markers: [NMFMarker] = []
    
    /// 지도 뷰를 특정 UIView에 초기화
    ///
    /// - Parameters:
    ///   - view: 지도를 표시할 UIView
    ///
    /// 호출 예시:
    /// ```swift
    /// mapManager.setupMap(in: view)
    /// ```
    func setupMap(in view: UIView) {
        mapView = NMFMapView(frame: view.bounds)
        
        guard let mapView = mapView else { return }
        mapView.touchDelegate = self
        mapView.positionMode = .direction
        
        // 위치 오버레이 설정
        locationOverlay = mapView.locationOverlay
        locationOverlay?.hidden = false
        
        view.addSubview(mapView)
        
        // 먼저 기존 위치 정보를 빠르게 가져와서 카메라 이동
        if let lastLocation = locationManager?.location {
            moveCameraToLocation(lastLocation)
        } else {
            // 위치 정보가 없으면 위치 요청 후 업데이트
            requestCurrentLocation()
        }
        
        setupLocationManager() // 위치 관리 초기화
    }
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation() // 현재 위치 요청
    }
    
    /// 현재 위치 업데이트
    func requestCurrentLocation() {
        locationManager?.requestLocation()
    }
    
    /// 지도 중심을 특정 위치로 업데이트
    ///
    /// - Parameters:
    ///   - location: 업데이트할 `CLLocation` 객체
    func moveCameraToLocation(_ location: CLLocation) {
        guard let mapView = mapView else { return }
        
        let currentPosition = NMGLatLng(
            lat: location.coordinate.latitude,
            lng: location.coordinate.longitude
        )
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: currentPosition)
        mapView.moveCamera(cameraUpdate)
        
        locationOverlay?.location = currentPosition
    }
    
    /// 탭 제스처 핸들러 설정
    ///
    /// - Parameters:
    ///   - handler: 탭한 위치 좌표를 전달하는 클로저
    ///
    /// 호출 예시:
    /// ```swift
    /// mapManager.setTapGestureHandler { coordinate in
    ///     print("탭한 위치: \(coordinate.latitude), \(coordinate.longitude)")
    /// }
    /// ```
    func setTapGestureHandler(_ handler: @escaping (Coordinate) -> Void) {
        tapGestureHandler = handler
    }
    
    /// 롱 탭 제스처 설정
    ///
    /// 호출 예시: 탭 제스처 핸들러와 동일
    func setLongTapGestureHandler(_ handler: @escaping (Coordinate) -> Void) {
        longTapGestureHandler = handler
    }
    
    /// 네이버 실내 지도 활성화 여부
    ///
    /// - Parameters:
    ///     - isEnabled: 활성화 여부(true면 실내 지도 활성화, false면 비활성화)
    /// 호출 예시:
    /// ```swift
    /// guard let naverMapManager = mapManager as? NaverMapManagerProtocol else { return }
    /// naverMapManager.setIndoorMapEnabled(true)
    /// ```
    func setIndoorMapEnabled(_ isEnabled: Bool) {
        mapView?.isIndoorMapEnabled = isEnabled
    }
    
    func addMarker(
        imageName: String,
        width: CGFloat,
        height: CGFloat,
        at coordinate: Coordinate
    ) {
        guard let mapView = mapView else { return }
        
        let marker = createMarker(
            icon: NMFOverlayImage(name: imageName),
            width: width,
            height: height,
            at: coordinate
        )
        
        marker.mapView = mapView
    }
    
    func addMarker(
        image: UIImage,
        width: CGFloat,
        height: CGFloat,
        at coordinate: Coordinate
    ) {
        guard let mapView = mapView else {
            print("NaverMapManager's addMarker: 지도 로드 실패")
            return
        }
        
        let marker = createMarker(
            icon: NMFOverlayImage(image: image),
            width: width,
            height: height,
            at: coordinate
        )
        
        marker.mapView = mapView
    }
    
    /// 내부적으로 마커 생성하는 공통 함수
    private func createMarker(
        icon: NMFOverlayImage,
        width: CGFloat,
        height: CGFloat,
        at coordinate: Coordinate
    ) -> NMFMarker {
        let marker = NMFMarker()
        marker.position = NMGLatLng(
            lat: coordinate.latitude,
            lng: coordinate.longitude
        )
        marker.iconImage = icon
        marker.width = width
        marker.height = height
        markers.append(marker)
        return marker
    }
    
    func removeAllMarkers() {
        markers.forEach { $0.mapView = nil }
        markers.removeAll()
    }
    
    /// 지도의 카메라 기준으로 경계값 가져옴
    func getVisibleBounds(
        sortBy: String?
    ) -> HotPlaceRequest {
        guard let mapView = mapView else {
            fatalError("NaverMapManager: 지도 로드 실패")
        }
        let bounds = mapView.contentBounds
        let southWest = bounds.southWest // 남서쪽 좌표
        let northEast = bounds.northEast // 북동쪽 좌표
        print("southWest: \(southWest)")
        print("northEast: \(northEast)")
        
        return HotPlaceRequest(
            minX: southWest.lng,
            maxX: northEast.lng,
            minY: southWest.lat,
            maxY: northEast.lat,
            sortBy: sortBy ?? "distance"
        )
    }
    
    /// 현재 위치 getter
    func getCurrentLocation(completion: @escaping (Coordinate?) -> Void) {
        if let location = currentLocation {
            completion(location)
        } else {
            print("위치 정보가 아직 없음, 업데이트 대기...")
            locationUpdateHandler = completion // 위치 업데이트 후 실행할 핸들러 저장
            requestCurrentLocation() // 현재 위치 요청 (필요할 경우)
        }
    }
}

// MARK: - Extension

extension NaverMapManager:
    CLLocationManagerDelegate,
    NMFMapViewTouchDelegate {
    
    // MARK: - NMFMapViewTouchDelegate
    
//    /// Tap 이벤트
//    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
//        let coordinate = Coordinate(latitude: latlng.lat, longitude: latlng.lng)
//        tapGestureHandler?(coordinate)
//    }
//    
//    /// Long Tab 이벤트
//    func mapView(_ mapView: NMFMapView, didLongTapMap latlng: NMGLatLng, point: CGPoint) {
//        let coordinate = Coordinate(latitude: latlng.lat, longitude: latlng.lng)
//        longTapGestureHandler?(coordinate)
//    }
    
//    /// 심벌 탭 이벤트
//    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
//        if symbol.caption == "한성대학교" {
//            print("한성대학교 탭")
//            return true
//            
//        } else {
//            print("symbol 탭")
//            return false
//        }
//    }
    
    // MARK: - CLLocationManagerDelegate
    
    // CLLocationManager에서 수집된 위치 정보를 처리하는 메서드
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else {
            locationUpdateHandler?(nil) // 업데이트 실패시 nil 반환
            return
        }
        
        moveCameraToLocation(location)
        // 현재 위치 저장
        currentLocation = Coordinate(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        locationUpdateHandler?(currentLocation) // 업데이트 완료 후 핸들러 실행
        locationUpdateHandler = nil // 핸들러 해제 (다음 요청을 위해)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 정보 업데이트 실패: \(error.localizedDescription)")
    }
}

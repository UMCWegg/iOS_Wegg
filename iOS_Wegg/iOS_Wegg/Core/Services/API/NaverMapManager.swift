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
    
    /// Wegg 아이콘 마커 생성
    ///
    /// - Parameters:
    ///     - coordinate: 좌표값
    func addMarker(at coordinate: Coordinate) {
        guard let mapView = mapView else { return }
        // 마커 위치 설정
        let markerPosition = NMGLatLng(
            lat: coordinate.latitude,
            lng: coordinate.longitude
        )
        // 마커 생성
        let marker = NMFMarker(position: markerPosition)
        marker.iconImage = NMFOverlayImage(name: "list_brown_icon")
        marker.width = 28
        marker.height = 40
        marker.mapView = mapView // 마커 지도에 추가
    }
    
    /// 지도의 카메라 기준으로 경계값 가져옴
    func getVisibleBounds(
        sortBy: String?
    ) -> HotPlaceRequest {
        guard let mapView = mapView else {
            fatalError("getVisibleBounds: 지도 로드 실패")
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
        guard let location = locations.first else { return }
        moveCameraToLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 정보 업데이트 실패: \(error.localizedDescription)")
    }
}

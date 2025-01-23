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
    }
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    /// 지도 중심을 특정 위치로 업데이트
    ///
    /// - Parameters:
    ///   - location: 업데이트할 `CLLocation` 객체
    func updateLocation(_ location: CLLocation) {
        guard let mapView = mapView else { return }
        let cameraUpdate = NMFCameraUpdate(
            scrollTo: NMGLatLng(
                lat: location.coordinate.latitude,
                lng: location.coordinate.longitude
            ))
        mapView.moveCamera(cameraUpdate)
        locationOverlay?.location = NMGLatLng(
            lat: location.coordinate.latitude,
            lng: location.coordinate.longitude
        )
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
    
    func requestCurrentLocation() {
        locationManager?.requestLocation()
    }
}

// MARK: - Extension

extension NaverMapManager:
    CLLocationManagerDelegate,
    NMFMapViewTouchDelegate {
    
    // MARK: - NMFMapViewTouchDelegate
    
    /// Tap 이벤트
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        let coordinate = Coordinate(latitude: latlng.lat, longitude: latlng.lng)
        tapGestureHandler?(coordinate)
    }
    
    /// Long Tab 이벤트
    func mapView(_ mapView: NMFMapView, didLongTapMap latlng: NMGLatLng, point: CGPoint) {
        let coordinate = Coordinate(latitude: latlng.lat, longitude: latlng.lng)
        longTapGestureHandler?(coordinate)
    }
    
    /// 심벌 탭 이벤트
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        if symbol.caption == "한성대학교" {
            print("한성대학교 탭")
            return true
            
        } else {
            print("symbol 탭")
            return false
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    // CLLocationManager에서 수집된 위치 정보를 처리하는 메서드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        updateLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 정보 업데이트 실패: \(error.localizedDescription)")
    }
}

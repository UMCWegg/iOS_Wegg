//
//  MapViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/20/25.
//

import UIKit
import NMapsMap

class MapViewController:
    UIViewController,
    CLLocationManagerDelegate,
    NMFMapViewTouchDelegate {
    private var mapView: NMFMapView?
    private var locationManager: CLLocationManager?
    private var locationOveralay: NMFLocationOverlay?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }
    
    // MARK: - 지도 뷰 띄우기
    
    private func setupView() {
        mapView = NMFMapView(frame: view.bounds)
        guard let mapView = mapView else {
            print("지도 로드 실패")
            return
        }
        view.addSubview(mapView)
        
        // 실내 지도 활성화
        mapView.isIndoorMapEnabled = true
        
        // 네이버 지도 SDK는 UIGestureRecognizer를 상속 받은 형태. 다향한 제스처 정의 가능
        mapView.touchDelegate = self
        
        // LocationOveraly 활성화
        locationOveralay = mapView.locationOverlay
        locationOveralay?.hidden = false
        
        mapView.positionMode = .direction
    }
    
    // MARK: - 위치
    
    /// 디바이스 현재 위치 추적
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else {
            print("현재 위치 추적 실패")
            return
        }
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    /// 디바이스 현재 위치 업데이트
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else { return }
        let currentLat = location.coordinate.latitude
        let currentLng = location.coordinate.longitude
        print(currentLat, currentLng)
    }
}

// MARK: - Extensions
extension MapViewController {
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: any Error
    ) {
        print("위치 정보 업데이트 실패: \(error.localizedDescription)")
    }
    
    /// 탭 제스처
    func mapView(
        _ mapView: NMFMapView,
        didTapMap latlng: NMGLatLng,
        point: CGPoint
    ) {
        print("탭: \(latlng.lat), \(latlng.lng)")
    }
    
    // 롱 탭 제스처
    func mapView(
        _ mapView: NMFMapView,
        didLongTapMap latlng: NMGLatLng,
        point: CGPoint
    ) {
        print("롱 탭: \(latlng.lat), \(latlng.lng)")
    }
    
    /// 심벌 탭 이벤트
    func mapView(
        _ mapView: NMFMapView,
        didTap symbol: NMFSymbol
    ) -> Bool {
        if symbol.caption == "한성대학교" {
            print("한성대학교 탭")
            return true
            
        } else {
            print("symbol 탭")
            return false
        }
    }
}

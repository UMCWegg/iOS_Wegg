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
}

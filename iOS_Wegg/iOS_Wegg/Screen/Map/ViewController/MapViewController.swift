//
//  MapViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/20/25.
//

import UIKit

class MapViewController: UIViewController {
    private let mapManager: MapManagerProtocol
    private let overlayView = MapOverlayView()
    
    /// 의존성 주입
    init(mapManager: MapManagerProtocol) {
        self.mapManager = mapManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupMap()
        setupMapManagerGestures()
        setupOverlayView()
    }
    
    // MARK: - Set Up
    
    private func setupMap() {
        mapManager.setupMap(in: view)
        mapManager.setupLocationManager()
    }
    
    private func setupOverlayView() {
        // MARK: - MapOverlayView setup
        overlayView.setupOverlayConstraints(in: view)
        
        // MARK: - MapOverlayView Gesture
        overlayView.onLocationImageButtonTap = { [weak self] in
            self?.didTabLocationButton()
        }
    }
    
    private func setupMapManagerGestures() {
        mapManager.setTapGestureHandler { latlng in
            // 지도 탭하면 Wegg 아이콘 마커 생성(추후 변경될 예정)
            self.mapManager.addMarker(at: latlng)
        }
        
        mapManager.setLongTapGestureHandler { latlng in
            print("롱탭한 위치: \(latlng.latitude), \(latlng.longitude)")
        }
    }
    
    // MARK: - MapOverlayView에서 실행될 함수들
    
    private func didTabLocationButton() {
        mapManager.requestCurrentLocation()
        print("didTabLocationButton")
    }
}

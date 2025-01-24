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
        setupGestures()
        setupOverlayView()
    }
    
    private func setupMap() {
        mapManager.setupMap(in: view)
        mapManager.setupLocationManager()
    }
    
    private func setupOverlayView() {
        overlayView.setupOverlayConstraints(in: view)
    }
    
    private func setupGestures() {
        mapManager.setTapGestureHandler { latlng in
            // 지도 탭하면 Wegg 아이콘 마커 생성(추후 변경될 예정)
            self.mapManager.addMarker(at: latlng)
        }
        
        mapManager.setLongTapGestureHandler { latlng in
            print("롱탭한 위치: \(latlng.latitude), \(latlng.longitude)")
        }
    }
    
    @objc private func didTabLocationButton() {
        mapManager.requestCurrentLocation()
        print("didTabLocationButton")
    }
}

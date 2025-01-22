//
//  MapViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/20/25.
//

import UIKit

class MapViewController: UIViewController {
    private let mapManager: MapManagerProtocol
    
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
    }
    
    private func setupMap() {
        mapManager.setupMap(in: view)
        mapManager.setupLocationManager()
    }
    
    private func setupGestures() {
        mapManager.setTapGestureHandler { latlng in
            print("탭한 위치: \(latlng.latitude), \(latlng.longitude)")
        }
        
        mapManager.setLongTapGestureHandler { latlng in
            print("롱탭한 위치: \(latlng.latitude), \(latlng.longitude)")
        }
    }
}

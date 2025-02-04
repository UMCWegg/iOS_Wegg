//
//  MapViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/20/25.
//

import UIKit
import FloatingPanel

/// 바텀 시트 레이아웃 커스텀 클래스
class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .full: FloatingPanelLayoutAnchor(
            absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea
        ),
        .half: FloatingPanelLayoutAnchor(
            fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea
        ),
        .tip: FloatingPanelLayoutAnchor(
            absoluteInset: MapViewLayout.initialBottomSheetHeight,
            edge: .bottom,
            referenceGuide: .safeArea
        )
    ]
}

class MapViewController:
    UIViewController,
    FloatingPanelControllerDelegate,
    UIGestureRecognizerDelegate {
    private let mapManager: MapManagerProtocol
    private var fpc: FloatingPanelController?
    private var mapSearchVC: MapSearchViewController?
    lazy var overlayView = MapOverlayView()
    
    /// 의존성 주입
    init(mapManager: MapManagerProtocol) {
        self.mapManager = mapManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Navigation Bar 숨김. 다음 화면에서도 보이지 않음.
        navigationController?.setNavigationBarHidden(true, animated: animated)
        // 뒤로가기 제스처 활성화
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupMap()
        setupMapManagerGestures()
        setupOverlayView()
        setupFloatingPanel()
    }
    
    // MARK: - Set Up
    
    private func setupMap() {
        mapManager.setupMap(in: view)
        mapManager.setupLocationManager()
    }
    
    private func setupOverlayView() {
        overlayView.setupOverlayConstraints(in: view)
        overlayView.gestureDelegate = self
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
    
    /// 바텀 시트 초기 설정
    private func setupFloatingPanel() {
        fpc = FloatingPanelController()
        guard let fpc = fpc else { return }
        let fpcSurfaceView = fpc.surfaceView
        fpc.delegate = self
        
        let hotPlaceSheetVC = HotPlaceSheetViewController()
        fpc.set(contentViewController: hotPlaceSheetVC)
        // 스크롤 추적
        fpc.track(scrollView: hotPlaceSheetVC.hotPlaceView.hotPlaceCollectionView)
        fpc.layout = MyFloatingPanelLayout()
        
        fpcSurfaceView.appearance.cornerRadius = 25
//        fpc.surfaceView.appearance.borderWidth = 1
//        fpc.surfaceView.appearance.borderColor = .secondary
        fpcSurfaceView.layer.shadowColor = UIColor.secondary.cgColor
        fpcSurfaceView.layer.shadowOpacity = 0.2
        fpcSurfaceView.layer.shadowOffset = CGSize(width: 0, height: -3)
        fpcSurfaceView.layer.shadowRadius = 7 // Blur 설정
        fpcSurfaceView.clipsToBounds = false // 그림자 표시 위해 설정
        
        fpc.addPanel(toParent: self)
    }
}

// MARK: MapOverlayGestureDelegate

extension MapViewController: MapOverlayGestureDelegate {
    
    func didDetectOnLocationButtonTapped() {
        mapManager.requestCurrentLocation()
    }
    
    func didPlaceSearchButtonTapped() {
        mapSearchVC = MapSearchViewController()
        guard let mapSearchVC = mapSearchVC else { return }
        navigationController?.pushViewController(mapSearchVC, animated: true)
    }
}

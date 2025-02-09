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
            fractionalInset: 0.12, edge: .top, referenceGuide: .safeArea
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
    /// `MapSearchViewController`도 의존성 주입하여 재사용 (옵셔널로 선언)
    private var mapSearchVC: MapSearchViewController?
    /// FloatingPanelController를 `MapViewController`에서 직접 관리하여 중복 생성을 방지
    let floatingPanel: FloatingPanelController
    /// `HotPlaceSheetViewController`를 한 번만 생성하여 재사용
    let hotPlaceSheetVC: HotPlaceSheetViewController
    /// `PlaceDetailViewController`도 한 번만 생성하여 FloatingPanel 내에서 재사용
    let placeDetailVC: PlaceDetailViewController
    
    lazy var overlayView = MapOverlayView().then {
        $0.placeSearchBar.searchTextFieldView.isUserInteractionEnabled = false
    }
    
    /// 의존성 주입
    /// `MapViewController`에서 모든 뷰 컨트롤러를 한 번만 생성하여 유지하도록 함
    init(mapManager: MapManagerProtocol) {
        self.mapManager = mapManager
        self.mapSearchVC = MapSearchViewController(mapVC: nil)
        self.floatingPanel = FloatingPanelController()
        self.hotPlaceSheetVC = HotPlaceSheetViewController(mapVC: nil)
        self.placeDetailVC = PlaceDetailViewController(mapVC: nil)
        
        super.init(nibName: nil, bundle: nil)
        // 각각의 ViewController에 `MapViewController`를 주입
        self.hotPlaceSheetVC.mapVC = self
        self.mapSearchVC?.mapVC = self
        self.placeDetailVC.mapVC = self
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
        overlayView.placeSearchBar.delegate = self
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
        floatingPanel.delegate = self
        floatingPanel.set(contentViewController: hotPlaceSheetVC)
        // 스크롤 추적
        floatingPanel.track(scrollView: hotPlaceSheetVC.hotPlaceView.hotPlaceCollectionView)
        // FloatingPanel 스타일 설정
        floatingPanel.layout = MyFloatingPanelLayout()
        floatingPanel.surfaceView.appearance.cornerRadius = 25
        floatingPanel.surfaceView.layer.shadowColor = UIColor.secondary.cgColor
        floatingPanel.surfaceView.layer.shadowOpacity = 0.2
        floatingPanel.surfaceView.layer.shadowOffset = CGSize(width: 0, height: -3)
        floatingPanel.surfaceView.layer.shadowRadius = 7
        floatingPanel.surfaceView.clipsToBounds = false
        floatingPanel.isRemovalInteractionEnabled = false // 패널 제거 인터랙션 비활성화
        floatingPanel.backdropView.isHidden = true // 패널 뒤 배경 숨김
        floatingPanel.surfaceView.backgroundColor = .clear
        floatingPanel.addPanel(toParent: self)
    }
    
    private func pushUniqueSearchViewWithAnimation() {
        guard let mapSearchVC = mapSearchVC else { return }
        guard let navigationController = self.navigationController else { return }

        // 네비게이션 스택을 직접 설정하여 MapViewController + MapSearchViewController만 유지
            /*
             현재 네비게이션 스택에서 기존의 `MapSearchViewController`를 제거한 후 새로운 `MapSearchViewController` 추가
             
             기존의 navigationController.viewControllers 배열에서 `MapSearchViewController`가 아닌
             화면들만 필터링하여 새로운 배열을 생성.
             
             - `viewControllers.filter { !$0.isKind(of: MapSearchViewController.self) }`
               → `isKind(of:)` 메서드를 사용하여 `MapSearchViewController` 타입인 뷰 컨트롤러를 제외.
               → 즉, 기존 네비게이션 스택에서 `MapSearchViewController`가 여러 개 쌓이는 문제를 방지함.
               
             - 이후 `viewControllers.append(mapSearchVC)`를 통해 새로운 검색 화면을 추가.
               → 이렇게 하면 네비게이션 스택에는 `MapViewController` + `MapSearchViewController`만 유지됨.
            */
        var viewControllers = navigationController
            .viewControllers.filter { !$0.isKind(of: MapSearchViewController.self) }
        viewControllers.append(mapSearchVC)

        // 커스텀 애니메이션 설정
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        transition.subtype = .fromRight

        // 애니메이션을 네비게이션 컨트롤러 뷰에 추가
        navigationController.view.layer.add(transition, forKey: kCATransition)

        // 네비게이션 스택 설정
        navigationController.setViewControllers(viewControllers, animated: false)
    }
}

extension MapViewController:
    MapOverlayGestureDelegate,
    MapSearchBarDelegate {
    
    // MARK: - MapOverlayGestureDelegate
    
    func didTapDetectOnLocationButton() {
        mapManager.requestCurrentLocation()
    }
    
    func didTapPlaceSearchButton() {
        guard let mapSearchVC = mapSearchVC else { return }
        navigationController?.pushViewController(mapSearchVC, animated: true)
        // 검색 버튼 탭한 경우 뒤로 가기 버튼 비활성화
        overlayView.placeDetailBackButton.isHidden = true
    }
    
    func didTapPlaceSearchBar() {
        pushUniqueSearchViewWithAnimation()
    }
    
    func didTapPlaceDetailBackButton() {
        overlayView.placeDetailBackButton.isHidden = true
        hotPlaceSheetVC.hotPlaceView.showBottomSheetComponents(isHidden: false)
        floatingPanel.set(contentViewController: hotPlaceSheetVC)
        floatingPanel.move(to: .half, animated: true)
    }
    
    // MARK: - MapSearchBarDelegate
    
    func didTapSearchBackButton() {
        pushUniqueSearchViewWithAnimation()
    }
}

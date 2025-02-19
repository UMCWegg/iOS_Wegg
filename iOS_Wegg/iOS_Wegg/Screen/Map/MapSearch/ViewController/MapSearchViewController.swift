//
//  MapSearchViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/1/25.
//

import UIKit
import Then

class MapSearchViewController: UIViewController {
    
    weak var mapVC: MapViewController?
    
    private var mapManager: MapManagerProtocol
    private let apiManager = APIManager()
    private let mapSearchTableHandler = MapSearchTableHandler()
    
    init(mapVC: MapViewController?, mapManager: MapManagerProtocol) { // 의존성 주입
        self.mapVC = mapVC
        self.mapManager = mapManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = mapSearchView
        apiManager.setCookie(value: CookieStorage.cookie)
        setupTableHandler()
        let request = HotplaceDetailInfoRequest(placeName: "스타벅스 월곡역점")
        
        Task {
            do {
                let response: HotplaceDetailInfoResponse = try await apiManager.request(
                    target: HotPlacesAPI.getPlaceDetailInfo(request: request)
                )
                print(response.result)
            } catch {
                print("❌ 실패: \(error)")
            }
        }
    }
    
    lazy var mapSearchView = MapSearchView().then {
        $0.searchBarView.delegate = self
        $0.searchResultView.delegate = mapSearchTableHandler
    }
    
    private func setupTableHandler() {
        mapSearchTableHandler.setupDataSource(
            for: mapSearchView.searchResultView
        )
        mapSearchTableHandler.didSelectPlace = { [weak self] place in
            print(place)
        }
    }
    
    private func searchPlace(keyword: String, at coordinate: Coordinate) {
        let request = SearchHotplaceRequest(
            keyword: keyword,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            page: 0,
            size: 15
        )
        
        Task {
            do {
                let response: SearchHotplaceResponse = try await apiManager.request(
                    target: HotPlacesAPI.searchHotPlaces(request: request)
                )
                let placeList: [String] = response.result.placeList.map {
                    $0.placeName
                }
                DispatchQueue.main.async { [weak self] in
                    self?.mapSearchTableHandler.updateSearchResults(placeList)
                }
            } catch {
                print("❌ 실패: \(error)")
            }
        }
    }

}

// MARK: - Delegate Extenstion

extension MapSearchViewController: MapSearchBarDelegate {
    func didTapSearchBackButton() {
        // navigationController에서 MapViewController 탐색
        if let hotPlaceSheetVC = mapVC?.hotPlaceSheetVC
            as? HotPlaceSheetViewController {
            let hotPlaceView = hotPlaceSheetVC.hotPlaceView
            hotPlaceView.showBottomSheetComponents(isHidden: false)
        }
        
        // 검색시 바텀시트 tip 위치로 이동
        mapVC?.floatingPanel.move(to: .tip, animated: false)
        mapVC?.floatingPanel.set(contentViewController: mapVC?.hotPlaceSheetVC)
        guard let mapVC = navigationController?.viewControllers.first(
            where: { $0 is MapViewController }) as? MapViewController else {
            return
        }
        mapVC.overlayView.placeSearchBar.isHidden = true
        navigationController?.popViewController(animated: true)
    }
    
    func didSearch(query: String) {
        // 검색시 바텀 시트 헤더 숨기기
        if let hotPlaceVC = mapVC?.hotPlaceSheetVC
            as? HotPlaceSheetViewController {
            let hotPlaceView = hotPlaceVC.hotPlaceView
            hotPlaceView.showBottomSheetComponents(isHidden: true)
        }
        
        // 검색시 바텀시트 half 위치로 이동
        mapVC?.floatingPanel.move(to: .half, animated: true)
        // navigationController에서 MapViewController 탐색
        guard let mapVC = navigationController?.viewControllers.first(
            where: { $0 is MapViewController }) as? MapViewController else {
            return
        }
        mapVC.overlayView.placeSearchBar.isHidden = false
        customNavigationAnimation(to: nil, isPush: false)
    }
    
    func didChangeSearchText(query: String) {
        mapManager.getCurrentLocation { [weak self] coordinate in
            guard let coordinate = coordinate else { return }
            if !query.isEmpty {
                self?.searchPlace(
                    keyword: query,
                    at: coordinate
                )
            } else {
                self?.mapSearchTableHandler.updateSearchResults([])
            }
        }
        
    }
}

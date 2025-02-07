//
//  MapSearchViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/1/25.
//

import UIKit
import Then

class MapSearchViewController: UIViewController {
    private let fpcManager = FloatingPanelManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = mapSearchView
    }
    
    lazy var mapSearchView = MapSearchView().then {
        $0.searchBarView.delegate = self
    }

}

// MARK: - Delegate Extenstion

extension MapSearchViewController: MapSearchBarDelegate {
    func didTapSearchBackButton() {
        // navigationController에서 MapViewController 탐색
        if let hotPlaceVC = fpcManager.getContentViewController()
            as? HotPlaceSheetViewController {
            let hotPlaceView = hotPlaceVC.hotPlaceView
            hotPlaceView.bottomSheetTitleStack.isHidden = false
            hotPlaceView.bottomSheetButtonStack.isHidden = false
            hotPlaceView.dividedLineView.isHidden = false
            hotPlaceView.updateCollectionViewLayout()
        }
        
        // 검색시 바텀시트 tip 위치로 이동
        fpcManager.fpc?.move(to: .tip, animated: false)
        fpcManager.fpc?.set(contentViewController: HotPlaceSheetViewController())
        guard let mapVC = navigationController?.viewControllers.first(
            where: { $0 is MapViewController }) as? MapViewController else {
            return
        }
        mapVC.overlayView.placeSearchBar.isHidden = true
        navigationController?.popViewController(animated: true)
    }
    
    func didSearch(query: String?) {
        print("Search button tapped with query: \(query ?? "empty")")
        // 검색시 바텀 시트 헤더 숨기기
        if let hotPlaceVC = FloatingPanelManager.shared.getContentViewController()
            as? HotPlaceSheetViewController {
            let hotPlaceView = hotPlaceVC.hotPlaceView
            hotPlaceView.bottomSheetTitleStack.isHidden = true
            hotPlaceView.bottomSheetButtonStack.isHidden = true
            hotPlaceView.dividedLineView.isHidden = true
            hotPlaceView.updateCollectionViewLayout()
        }
        
        // 검색시 바텀시트 half 위치로 이동
        fpcManager.fpc?.move(to: .half, animated: true)
        fpcManager.fpc?.set(contentViewController: PlaceDetailViewController())
        // navigationController에서 MapViewController 탐색
        guard let mapVC = navigationController?.viewControllers.first(
            where: { $0 is MapViewController }) as? MapViewController else {
            return
        }
        mapVC.overlayView.placeSearchBar.isHidden = false
        customNavigationAnimation(to: nil, isPush: false)
    }
}

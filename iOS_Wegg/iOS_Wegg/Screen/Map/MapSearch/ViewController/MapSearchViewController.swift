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
    
    init(mapVC: MapViewController?) { // 의존성 주입
        self.mapVC = mapVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        if let hotPlaceSheetVC = mapVC?.hotPlaceSheetVC
            as? HotPlaceSheetViewController {
            let hotPlaceView = hotPlaceSheetVC.hotPlaceView
            hotPlaceView.bottomSheetTitleStack.isHidden = false
            hotPlaceView.bottomSheetButtonStack.isHidden = false
            hotPlaceView.dividedLineView.isHidden = false
            hotPlaceView.updateCollectionViewLayout()
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
    
    func didSearch(query: String?) {
        print("Search button tapped with query: \(query ?? "empty")")
        // 검색시 바텀 시트 헤더 숨기기
        if let hotPlaceVC = mapVC?.hotPlaceSheetVC
            as? HotPlaceSheetViewController {
            let hotPlaceView = hotPlaceVC.hotPlaceView
            hotPlaceView.bottomSheetTitleStack.isHidden = true
            hotPlaceView.bottomSheetButtonStack.isHidden = true
            hotPlaceView.dividedLineView.isHidden = true
            hotPlaceView.updateCollectionViewLayout()
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
}

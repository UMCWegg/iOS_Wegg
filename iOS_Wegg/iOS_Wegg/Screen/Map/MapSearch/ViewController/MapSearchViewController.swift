//
//  MapSearchViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/1/25.
//

import UIKit
import Then

class MapSearchViewController: UIViewController {

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
        navigationController?.popViewController(animated: true)
    }
    
    func didSearch(query: String?) {
        print("Search button tapped with query: \(query ?? "empty")")
        
        // navigationController에서 MapViewController 탐색
        guard let mapVC = navigationController?.viewControllers.first(
            where: { $0 is MapViewController }) as? MapViewController else {
            return
        }
        mapVC.overlayView.placeSearchBar.isHidden = false
        customNavigationAnimation(to: nil, isPush: false)
    }
}

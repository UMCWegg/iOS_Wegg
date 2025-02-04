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
    
    func didTapSearchBox() {
        print("didTapSearchBox")
    }
    
    func didTapSearchBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func didSearch(query: String?) {
        print("Search button tapped with query: \(query ?? "empty")")
    }
}

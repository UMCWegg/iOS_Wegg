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
        // Do any additional setup after loading the view.
    }
    
    lazy var mapSearchView = MapSearchView().then {
        $0.gestureDelegte = self
    }

}

extension MapSearchViewController:
    MapSearchViewGestureDelegate {
    
    func didTapSearchBackButton() {
        print("뒤로 가기")
    }
    
    func didTapSearchButton() {
        print("검색 하기")
    }
    
}

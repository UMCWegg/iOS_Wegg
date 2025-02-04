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

// MARK: - Delegate Extenstion

extension MapSearchViewController:
    MapSearchViewGestureDelegate,
    UITextFieldDelegate {
    
    // MARK: - MapSearchViewGestureDelegate
    
    func didTapSearchBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func didTapSearchButton() {
        print("검색 하기")
    }
    
    // MARK: - UITextFieldDelegate
    
    // 탭하여 편집을 시작할 때 호출
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    // 엔터(Return 키) 누를 때 호출되는 함수(검색 결과 처리)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text,
              !query.isEmpty else {
            return false
        }
        
        print("입력된 값: \(query)")
        
        return true
    }
}

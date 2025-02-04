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
        $0.searchTextFieldView.delegate = self
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
    
    // 엔터(Return 키) 누를 때 호출되는 함수
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("입력된 값: \(textField.text ?? "")")
        textField.resignFirstResponder() // 키보드 내리기
        return true
    }
}

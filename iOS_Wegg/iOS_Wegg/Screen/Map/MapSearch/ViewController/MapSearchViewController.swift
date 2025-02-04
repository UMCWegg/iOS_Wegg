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
    
    // 탭하여 편집을 시작할 때 호출
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                // alpha 값을 0으로 설정하여 뷰가 사라지도록 함(추후 복귀 용이)
                self?.mapSearchView.searchResultView.alpha = 0.0
            },
            completion: { [weak self] _ in
                self?.mapSearchView.searchResultView.isHidden = true
            }
        )
    }
    
    // 엔터(Return 키) 누를 때 호출되는 함수(검색 결과 처리)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text,
              !query.isEmpty else {
            return false
        }
        
        print("입력된 값: \(query)")
        // 검색 결과 뷰 다시 표시
        mapSearchView.searchResultView.isHidden = false
        mapSearchView.searchResultView.alpha = 0.0 // 먼저 투명하게 설정
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.mapSearchView.searchResultView.alpha = 1.0 // 서서히 나타남
        }
        
        textField.resignFirstResponder() // 키보드 내리기
        
        return true
    }
}

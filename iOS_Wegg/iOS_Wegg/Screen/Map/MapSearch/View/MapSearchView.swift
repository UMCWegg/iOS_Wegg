//
//  MapSearchView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/3/25.
//

import UIKit
import Then

class MapSearchView: UIView {
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property
    
    lazy var searchBarView = MapSearchBar()
    
    lazy var searchResultView = UITableView(
        frame: .zero,
        style: .plain
    ).then {
        $0.register(
            MapSearchTableCell.self,
            forCellReuseIdentifier: MapSearchTableCell.reuseIdentifier
        )
        $0.separatorStyle = .none
        $0.rowHeight = 60
        $0.backgroundColor = .white
    }
    
    /// 키보드 내리는 핸들러
    @objc private func handleDismissKeyboard() {
        endEditing(true)
        // TODO: 테이블 셀 모두 비우기
    }
    
}

// MARK: - Setup Extension

private extension MapSearchView {
    func setupView() {
        setupGestures()
        addComponenets()
        constraints()
    }
    
    func setupGestures() {
        // 키보드 내리는 제스처 추가
        let dismissKeyboardGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleDismissKeyboard)
        )
        dismissKeyboardGesture.cancelsTouchesInView = false
        addGestureRecognizer(dismissKeyboardGesture)
    }
    
    func addComponenets() {
        [searchBarView, searchResultView].forEach {
            addSubview($0)
        }
    }
    
    func constraints() {
        searchBarView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(
                MapViewLayout.PlaceSearch.searchBarHeight
            )
        }
        
        searchResultView.snp.makeConstraints { make in
            make.top.equalTo(searchBarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
}

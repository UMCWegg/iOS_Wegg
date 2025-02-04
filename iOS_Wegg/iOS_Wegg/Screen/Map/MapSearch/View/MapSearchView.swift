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
    
}

// MARK: - Setup Extension

private extension MapSearchView {
    func setupView() {
        addComponenets()
        constraints()
    }
    
    func addComponenets() {
        [searchBarView].forEach {
            addSubview($0)
        }
    }
    
    func constraints() {
        searchBarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(50)
        }
    }
}

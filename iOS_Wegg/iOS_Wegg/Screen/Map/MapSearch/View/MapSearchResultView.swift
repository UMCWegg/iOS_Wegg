//
//  MapSearchResultView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/4/25.
//

import UIKit

class MapSearchResultView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property
    
}

// MARK: - Setup Extenstion

private extension MapSearchResultView {
    func setupView() {
        addComponenets()
        constraints()
    }
    
    func addComponenets() {
        
    }
    
    func constraints() {
        
    }
}

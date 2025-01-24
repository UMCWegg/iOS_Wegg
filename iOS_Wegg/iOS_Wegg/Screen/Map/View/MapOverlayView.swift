//
//  MapView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/24/25.
//

import UIKit
import SnapKit
import Then

class MapOverlayView: UIView {
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addComponents()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// MapOverlayView의 기본 레이아웃 설정(전체 화면)
    func setupOverlayConstraints(in parentView: UIView) {
        parentView.addSubview(self)
        snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Property
    
    private let locationButton = UIImageView().then {
        $0.image = UIImage(named: "current_position")
        $0.contentMode = .scaleAspectFit
    }
    
}

// MARK: - Extensions

private extension MapOverlayView {
    func addComponents() {
        [locationButton].forEach {
            addSubview($0)
        }
    }
    
    func constraints() {
        locationButton.snp.makeConstraints { make in
            make.leading.equalTo(327)
            make.trailing.equalTo(-21)
            make.bottom.equalTo(-21)
        }
    }
}

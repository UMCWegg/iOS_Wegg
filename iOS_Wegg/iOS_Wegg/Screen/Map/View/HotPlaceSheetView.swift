//
//  HotPlaceSheetView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/28/25.
//

import UIKit
import SnapKit

class HotPlaceSheetView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var hotPlaceCollectionView = UICollectionView(
        frame: bounds,
        collectionViewLayout: HotPlaceCollectionLayout.createCompositionalLayout()
    ).then {
        $0.register(
            HotPlaceCellHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HotPlaceCellHeader.identifier
        )
        
        $0.register(
            HotPlaceCell.self,
            forCellWithReuseIdentifier: HotPlaceCell.identifier
        )
    }
    
    private func addComponents() {
        addSubview(hotPlaceCollectionView)
        hotPlaceCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

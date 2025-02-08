//
//  PlaceDetailCollectionLayout.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/06/25.
//

import UIKit

class PlaceDetailCollectionLayout {
    
    // MARK: - Constants
    
    private static let itemWidth: CGFloat = 182
    private static let itemHeight: CGFloat = 240
    private static let itemSpacing: CGFloat = 8
    
    /// 컬렉션뷰가 가지는 레이아웃 지정
    static func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            createPlaceSection()
        }
    }
    
    // MARK: - 컬렉션뷰 섹션 생성
    
    private static func createPlaceSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(itemHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth + itemSpacing),
            heightDimension: .absolute(itemHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(itemSpacing)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
}

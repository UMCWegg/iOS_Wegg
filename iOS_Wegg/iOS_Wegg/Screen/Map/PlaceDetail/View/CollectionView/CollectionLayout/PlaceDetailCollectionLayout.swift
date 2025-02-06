//
//  PlaceDetailCollectionLayout.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/06/25.
//

import UIKit

class PlaceDetailCollectionLayout {
    /// 컬렉션뷰가 가지는 레이아웃 지정
    static func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
            guard section < HotPlaceSectionModel.sampleSections.count else {
                return nil
            }
            return createPlaceSection()
        }
    }
    
    // MARK: 컬렉션뷰 섹션 생성
    
    private static func createPlaceSection() -> NSCollectionLayoutSection {
        let itemSpacing: CGFloat = 8
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(182),
            heightDimension: .absolute(240)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(182 + itemSpacing),
            heightDimension: .absolute(240)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(itemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        return section
    }
}

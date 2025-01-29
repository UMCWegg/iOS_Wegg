//
//  HotPlaceCollectionLayout.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/28/25.
//

import UIKit

class HotPlaceCollectionLayout {
    /// 컬렉션뷰가 가지는 레이아웃 지정
    static func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                return createPlaceSection()
            default:
                return nil
            }
        }
    }
    
    private static func createPlaceSection() -> NSCollectionLayoutSection {
        let itemSpacing: CGFloat = 8
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(104),
            heightDimension: .absolute(138)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(104 + itemSpacing),
            heightDimension: .absolute(138)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(itemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 10,
            bottom: 10,
            trailing: 10
        )
        
        section.boundarySupplementaryItems = [
            createHeaderItem()
//            createFooterItem()
        ]
        
        return section
    }
    
    /// 헤더 생성(특정 섹션에 대해 타이틀 헤더)
    /// - Returns: 고정된 헤더 반환
    private static func createHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.pinToVisibleBounds = false // 화면에 고정 안함
        
        return header
    }
    
    /// 푸터 생성(구분선)
    /// - Returns: 구분선을 가로(동적 사이즈), 세로(고정 사이즈)로 조정하여 각 섹션마다 생성할 수 있도록 푸터 반환
    private static func createFooterItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        /*
         구분선이 푸터로, 구분선의 길이를 지정
         구분 선 푸터 뷰를 따로 커스텀으로 만들어두었기 떄문에 전체 가로 길이가 되도록 fraction으로 처리.
         */
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(1)
        )
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        return footer
    }
}

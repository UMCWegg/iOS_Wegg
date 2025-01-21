//
//  BrowseView.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/17/25.
//

import UIKit
import SnapKit

class BrowseView: UIView {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    /// 게시물과 사용자 정보를 보여주는 둘러보기 CollectionView
    public lazy var browseCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    // MARK: - Methods
    
    /// UI 구성 요소 추가
    private func setupView() {
        addSubview(browseCollectionView)
    }
    
    /// UI 제약 조건 설정
    private func setupConstraints() {
        browseCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(
                UIEdgeInsets(top: 120, left: 0, bottom: 50, right: 0)
            )
        }
    }
    
    /// 컬렉션 뷰 레이아웃 생성
        private func createLayout() -> UICollectionViewFlowLayout {
            let layout = UICollectionViewFlowLayout()
            
            // 열 개수 및 여백 설정
            let numberOfColumns: CGFloat = 2 // 표시할 열의 개수
            let horizontalSpacing: CGFloat = 30 // 열 간격
            let sectionInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30) // 섹션 여백
            
            // 아이템 크기를 설정하기 위한 화면 너비에서 여백과 간격 계산
            let totalHorizontalSpacing = sectionInsets.left // 10
            + sectionInsets.right // 10
            + (horizontalSpacing * (numberOfColumns - 1)) // 10 + 10 + 10
            
            // 아이템 크기 설정하기. 전체화면에서 여백을 뺀 나머지 크기 열로 나누기
            let itemWidth = (UIScreen.main.bounds.width - totalHorizontalSpacing) / numberOfColumns
            
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
            layout.minimumLineSpacing = 30 // 행 간격
            layout.minimumInteritemSpacing = horizontalSpacing // 열 간격
            layout.sectionInset = sectionInsets
            
            return layout
    }
}

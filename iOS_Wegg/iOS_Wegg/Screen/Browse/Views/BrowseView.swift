//
//  BrowseView.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/17/25.
//

import UIKit
import SnapKit
import Then

class BrowseView: UIView {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addcomponents()
        setupConstraints()
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    /// 게시물과 사용자 정보를 보여주는 둘러보기 CollectionView
    public lazy var browseCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.backgroundColor = .white
    }
    
    /// 검색바 헤더 뷰 추가
    public lazy var searchView: SearchView = SearchView()
    
    // MARK: - Methods
    
    /// UI 구성 요소 추가
    private func addcomponents() {
        [
            searchView,
            browseCollectionView
        ].forEach {
            self.addSubview($0)
        }
        
    }
    
    /// UI 제약 조건 설정
    private func setupConstraints() {
        searchView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        browseCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom).offset(10) // 검색바 아래에 위치하도록 수정
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    /// 컬렉션 뷰 레이아웃 생성
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        // 열 개수 및 여백 설정
        let horizontalSpacing: CGFloat = 12 // 열 간격
        let sectionInsets = UIEdgeInsets(top: 10, left: 21, bottom: 10, right: 21) // 섹션 여백
        
        layout.itemSize = CGSize(width: 160, height: 264) // 고정된 크기
        layout.minimumLineSpacing = 13 // 행 간격
        layout.minimumInteritemSpacing = horizontalSpacing // 열 간격
        layout.sectionInset = sectionInsets
        
        return layout
    }
}

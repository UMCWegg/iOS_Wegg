//
//  BrowseViewController.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/17/25.
//

import UIKit

class BrowseViewController: UIViewController {
    
    // MARK: - Properties
    
    /// 둘러보기 커스텀 뷰
    private let browseView = BrowseView()
    
    /// Mock 데이터를 담을 배열
    private var browseItems: [BrowseItem] = []
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = browseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadMockData()
    }
    
    // MARK: - Methods
    
    /// CollectionView 초기 설정하기
    private func setupCollectionView() {
        browseView.browseCollectionView.register(
            BrowseCell.self,
            forCellWithReuseIdentifier: "BrowseCell"
        )
        browseView.browseCollectionView.dataSource = self
        browseView.browseCollectionView.delegate = self
    }
    
    // MARK: - Data Methods
    
    /// Mock 데이터(임시로 설정한 데이터입니다.)를 로드
    private func loadMockData() {
        browseItems = [
            BrowseItem(
                nickName: "증윤",
                profileImage: "profile1",
                postImage: ["post1-1", "post1-2"]
            ),
            BrowseItem(
                nickName: "리버",
                profileImage: "profile1",
                postImage: ["post1-1", "post2-2"]
            ),
            BrowseItem(
                nickName: "하키",
                profileImage: "profile1",
                postImage: ["post1-1", "post3-2"]
            ),
            BrowseItem(
                nickName: "베텔",
                profileImage: "profile1",
                postImage: ["post1-1", "post1-2"]
            ),
            BrowseItem(
                nickName: "소피",
                profileImage: "profile1",
                postImage: ["post1-1", "post2-2"]
            ),
            BrowseItem(
                nickName: "증윤",
                profileImage: "profile1",
                postImage: ["post1-1", "post1-2"]
            ),
            BrowseItem(
                nickName: "리버",
                profileImage: "profile1",
                postImage: ["post1-1", "post2-2"]
            ),
            BrowseItem(
                nickName: "증윤",
                profileImage: "profile1",
                postImage: ["post1-1", "post1-2"]
            ),
            BrowseItem(
                nickName: "리버",
                profileImage: "profile1",
                postImage: ["post1-1", "post2-2"]
            )
            
        ]
        browseView.browseCollectionView.reloadData()
    }
}

// MARK: - Extensions

/// UICollectionViewDataSource: 콜렉션 뷰의 데이터 개수와 내용을 담는 확장자
extension BrowseViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return browseItems.count // 배열의 데이터 개수를 반환
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "BrowseCell",
            for: indexPath
        ) as? BrowseCell else {
            fatalError("Unable to dequeue BrowseCell") // 디버그용 오류 로그
        }
        
        let item = browseItems[indexPath.row]
        cell.configure(with: item) // 데이터 설정
        return cell
    }
}

/// UICollectionViewDelegate: 사용자 반응 처리하기 위한 프로토콜
extension BrowseViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let selectedItems = browseItems[indexPath.row]
        
        // 게시물 상세 화면으로 이동하는 네비게이션 컨트롤러 구현 예정
    }
}

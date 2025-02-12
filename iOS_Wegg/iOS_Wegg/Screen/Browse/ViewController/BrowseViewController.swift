//
//  BrowseViewController.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/17/25.
//

import UIKit
import Then

class BrowseViewController: UIViewController {
    
    // MARK: - Properties
    
    /// 둘러보기 커스텀 뷰
    private let browseView = BrowseView()
    
    /// Mock 데이터를 담을 배열
    private var browseItems: [BrowseItem] = []
    
    /// 리프레쉬 버튼 생성
    private lazy var refreshControl = UIRefreshControl().then {
        $0.addTarget(
            self,
            action: #selector(pullRefresh),
            for: .valueChanged)
    }
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = browseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchMockData()
        setupRefreshControl()
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
    
    /// 리프레시 컨트롤 설정 (UICollectionView에 추가)
        private func setupRefreshControl() {
            browseView.browseCollectionView.refreshControl = refreshControl
        }
    
    /// 1.0초 동안 리프레시 버튼 실행 후 데이터 리로드
       @objc private func pullRefresh() {
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
               self.fetchMockData()  // 새 데이터 로드
               self.refreshControl.endRefreshing()
           }
       }
    
    // MARK: - Data Methods
    
    /// Mock데이터 호출하는 메서드
    private func fetchMockData() {
        browseItems = BrowseItem.mockData()
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

/// UICollectionViewDelegate: 사용자 반응 처리(아이템 클릭시 처리)하기 위한 프로토콜
extension BrowseViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        // 선택된 BrowseItem 가져오기
        let selectedItems = browseItems[indexPath.row]
        print(selectedItems)
        
        // 선택된 아이템 셀을 MockData 메서드를 활용해 Model에 전달
        let detail = PostDetailModel.mockData(for: selectedItems)
        
        // 네비게이션 방식으로 게시물 상세 페이지 표시, 의존성 주입
        let detailVC = PostDetailViewController(postDetailModel: detail)
        // 탭바 숨겨서 컨트롤러 push하기
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

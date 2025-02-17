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
    private let browseService = BrowseService()
    
    /// API에서 받아온 게시물 데이터
    private var browsePosts: [[BrowsePost]] = []
    
    /*/// Mock 데이터를 담을 배열
     private var browseItems: [BrowseItem] = []
     */
    
    /// API 중복 요청 방지 변수
    private var isFetching = false
    
    /// 리프레쉬 버튼
    private lazy var refreshControl = UIRefreshControl().then {
        $0.addTarget(
            self,
            action: #selector(pullRefresh),
            for: .valueChanged)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = browseView
        view.backgroundColor = .yellowWhite
        setupCollectionView()
        fetchBrowsePosts() // BrowseVC 탭 최초 API 호출
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 이 화면에 들어올 때 네비게이션 바 숨김
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 이 화면을 벗어날 때 네비게이션 바 다시 표시
        navigationController?.setNavigationBarHidden(false, animated: true)
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
        browseView.browseCollectionView.register(
            BrowseSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "HeaderView"
        )
    }
    
    /// 리프레시 컨트롤 설정 (UICollectionView에 추가)
    private func setupRefreshControl() {
        browseView.browseCollectionView.refreshControl = refreshControl
    }
    
    /// 1.0초 동안 리프레시 버튼 실행 후 데이터 리로드
    @objc private func pullRefresh() {
        fetchBrowsePosts() // API 호출
    }
    
    // MARK: - Data Methods, API Methods
    
    /*/// Mock데이터 호출하는 메서드
     private func fetchMockData() {
     browseItems = BrowseItem.mockData()
     browseView.browseCollectionView.reloadData()
     }
     */
    
    /// API 호출하여 최신 게시물 가져오기
    private func fetchBrowsePosts() {
        guard !isFetching else { return }
        isFetching = true
        
        Task {
            do {
                // ✅ 서버 응답은 [[BrowsePost]] 형태로 반환
                let posts = try await self.browseService.fetchBrowsePosts(page: 0, size: 20)
                DispatchQueue.main.async {
                    // ✅ 응답 그대로 사용
                    self.browsePosts = posts
                    self.browseView.browseCollectionView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.isFetching = false
                }
            } catch {
                print("API 호출 실패: \(error)")
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.isFetching = false
                }
            }
        }
    }
}

// MARK: - Extensions

/*
 ex) result [[BrowsePost]] 2차원 배열임 -> result[0] = 내가 팔로우한 사람 게시물, result[1] = 내가 팔로우하지 않은 사람
 ✔ numberOfSections(in:) → 섹션 마다 개수를 browsePosts.count로 반환 (2개, 팔로우 O/X)
 ✔ numberOfItemsInSection → 각 섹션별 게시물 개수를 반환 (browsePosts[section].count)
 ✔ cellForItemAt → 2차원 배열(browsePosts[indexPath.section][indexPath.row])을 처리하도록 변경
 */
/// UICollectionViewDataSource: 섹션마다 데이터 소스를 분리하여 처리
extension BrowseViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return browsePosts.count // ✅ 섹션 개수는 팔로우 O / 팔로우 X
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return browsePosts[section].count // ✅ 각 섹션별 게시물 개수
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "BrowseCell",
            for: indexPath
        ) as? BrowseCell else {
            fatalError("Unable to dequeue BrowseCell")
        }
        
        let item = browsePosts[indexPath.section][indexPath.row] // ✅ 2차원 배열 처리
        cell.configure(with: item)
        return cell
    }
    
    // ✅ 섹션 헤더를 추가하여 팔로우 여부를 표시
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "HeaderView",
                for: indexPath
              ) as? BrowseSectionHeaderView else {
            return UICollectionReusableView()
        }
        
        headerView.titleLabel.text = indexPath.section == 0 ? "팔로우한 사용자의 게시물" : "팔로우하지 않은 사용자의 게시물"
        return headerView
    }
}
/// UICollectionViewDelegate: 사용자 반응 처리(아이템 클릭시 처리)하기 위한 프로토콜
extension BrowseViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        // ✅ 2차원 배열에서 올바른 `BrowsePost` 가져오기
        let selectedPost = browsePosts[indexPath.section][indexPath.row]
        
        // ✅ BrowsePost → PostDetailModel 변환
        let detailModel = PostDetailModel(from: selectedPost)
        
        // ✅ PostDetailViewController에 올바른 데이터 전달
        let detailVC = PostDetailViewController(postDetailModel: detailModel)
        
        // 탭바 숨겨서 컨트롤러 push하기
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

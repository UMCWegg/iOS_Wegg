//
//  PlaceDetailViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/5/25.
//

import UIKit

class PlaceDetailViewController: UIViewController {
    var targetSectionIndex: Int = 0 // 모델에서 원하는 인덱스 설정
    private var detailData: HotPlaceDetailModel?
    private lazy var placeDetailView = PlaceDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = placeDetailView
        configureCollectionView()
        loadDetailData()
    }
    
    private func configureCollectionView() {
        placeDetailView.studyImageCollectionView.delegate = self
        placeDetailView.studyImageCollectionView.dataSource = self
        placeDetailView.gestureDelegate = self
    }
    
    private func loadDetailData() {
        Task {
            let mockData = await fetchDetailData()
            updateUI(with: mockData)
        }
    }
    
    /**
     비동기적으로 상세 데이터를 가져오는 함수
     - Returns: `HotPlaceDetailModel`을 반환
     */
    private func fetchDetailData() async -> HotPlaceDetailModel {
        // 임시 Mock 데이터이므로 0.5초 지연
        try? await Task.sleep(for: .milliseconds(500))
        // 임시 반환
        return HotPlaceDetailModel(
            phoneNumber: "1522-3232",
            openingInfo: "영업 중 · 매장 22:00에 영업 종료",
            websiteURL: "http://www.starbucks.co.kr/"
        )
    }
    
    /**
     메인 스레드에서 UI를 업데이트하는 함수
     - Parameter detail: `HotPlaceDetailModel` 데이터
     */
    @MainActor
    private func updateUI(with detail: HotPlaceDetailModel) {
        detailData = detail
        
        print("Phone: \(detail.phoneNumber)")
        print("Hours: \(detail.openingInfo)")
        print("Website: \(detail.websiteURL)")
        
        // TODO: [25.02.05] UI 업데이트 작업 - 작성자: 이재원
        let info = [
            placeDetailView.verificationCount: "인증 99+",
            placeDetailView.saveCount: "저장 34",
            placeDetailView.addressLabel: "서울특별시 강남구 강남대로101길 101",
            placeDetailView.phoneNumberLabel: detail.phoneNumber,
            placeDetailView.openingInfoLabel: detail.openingInfo,
            placeDetailView.webUrlLabel: detail.websiteURL
        ]
        
        info.forEach { $0.key.text = $0.value }
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension PlaceDetailViewController:
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource {
    
    /// 컬렉션 뷰에서 하나의 섹션만 표시
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /// 특정 인덱스(`targetSectionIndex`)에 해당하는 섹션의 아이템 개수를 반환
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return HotPlaceSectionModel.sampleSections[
            safe: targetSectionIndex
        ]?.items.count ?? 0
    }
    
    /// 특정 인덱스(`targetSectionIndex`)의 섹션에서 셀을 생성하고 데이터를 설정
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PlaceDetailImageCell.identifier,
            for: indexPath
        ) as? PlaceDetailImageCell else {
            fatalError("Could not dequeue PlaceDetailImageCell")
        }
        
        // safe를 통해`targetSectionIndex`와 `indexPath.row`가 안전한 범위 내에 있는 경우만 실행
        if let section = HotPlaceSectionModel.sampleSections[safe: targetSectionIndex],
           let data = section.items[safe: indexPath.row] {
            cell.configure(model: data)
        }
        
        return cell
    }
    
    // 컬렉션 뷰에서 행(줄) 간 간격 설정
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 14
    }
    
    // 같은 행(라인) 내에서 아이템 간 최소 간격 설정
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    // 컬렉션 뷰의 특정 아이템이 선택되었을 때 실행되는 이벤트 처리
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if indexPath.section == 0 && indexPath.item == 0 {
            print("이미지 컬렉션뷰 탭")
        }
    }
}

extension PlaceDetailViewController: PlaceDetailViewGestureDelegate {
    func didTapFavoriteStar() {
        print("didTapFavoriteStar")
    }
    
    func didTapPlaceCreateButton() {
        print("didTapPlaceCreateButton")
    }
    
}

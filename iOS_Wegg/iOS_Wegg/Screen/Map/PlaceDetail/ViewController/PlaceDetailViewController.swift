//
//  PlaceDetailViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/5/25.
//

import UIKit
import Then

class PlaceDetailViewController: UIViewController {
    private var detailData: HotPlaceDetailModel?
    var targetSectionIndex: Int = 0 // 원하는 섹션 인덱스 설정
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = placeDetailView
        loadDetailData()
    }
    
    lazy var placeDetailView = PlaceDetailView().then {
        $0.studyImageCollectionView.delegate = self
        $0.studyImageCollectionView.dataSource = self
    }
    
    private func loadDetailData() {
        Task {
            // 비동기로 데이터 로드
            let mockData = await fetchDetailData()
            
            // UI 업데이트
            updateUI(with: mockData)
        }
    }
    
    /**
     비동기적으로 상세 데이터를 가져오는 함수
     - Returns: `HotPlaceDetailModel`을 반환
     */
    private func fetchDetailData() async -> HotPlaceDetailModel {
        // 임시 Mock 데이터이므로 0.5초 지연
        try? await Task.sleep(nanoseconds: 500_000_000)
        // 임시로 반환
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
        self.detailData = detail
        print("Phone: \(detail.phoneNumber)")
        print("Hours: \(detail.openingInfo)")
        print("Website: \(detail.websiteURL)")
        
        // TODO: [25.02.05] UI 업데이트 작업 - 작성자: 이재원
        placeDetailView.verificationCount.text = "인증 99+"
        placeDetailView.saveCount.text = "저장 34"
        placeDetailView.addressLabel.text = "서울특별시 강남구 강남대로101길 101"
        placeDetailView.phoneNumberLabel.text = detail.phoneNumber
        placeDetailView.openingInfoLabel.text = detail.openingInfo
        placeDetailView.webUrlLabel.text = detail.websiteURL
    }
}

// MARK: - Delegate & DataSource Extenstion

extension PlaceDetailViewController:
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource {
    
    /// 컬렉션 뷰에서 하나의 섹션만 표시
    /// - 장소 상세 화면에서는 하나의 섹션만 필요하므로 1을 반환
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /// 특정 인덱스(`targetSectionIndex`)에 해당하는 섹션의 아이템 개수를 반환
    /// - `targetSectionIndex`가 `sampleSections`의 범위를 벗어나지 않는지 확인 후 반환
    /// - 유효한 인덱스가 아닐 경우, 안전하게 0을 반환하여 크래시 방지
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard HotPlaceSectionModel.sampleSections.indices.contains(targetSectionIndex) else {
            return 0
        }
        return HotPlaceSectionModel.sampleSections[targetSectionIndex].items.count
    }
    
    /// 특정 인덱스(`targetSectionIndex`)의 섹션에서 셀을 생성하고 데이터를 설정
    /// - `PlaceDetailImageCell`을 사용하여 셀을 구성
    /// - `targetSectionIndex`가 유효한지 확인 후 해당 섹션의 데이터만 사용
    /// - `indexPath.row`가 `items` 배열의 범위를 초과하지 않는지 검사하여 안전하게 접근
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
        
        // `targetSectionIndex`가 유효한지 확인 (배열 범위 초과 방지)
        guard HotPlaceSectionModel.sampleSections.indices.contains(targetSectionIndex) else {
            fatalError("Invalid targetSectionIndex: \(targetSectionIndex)")
        }
        
        let section = HotPlaceSectionModel.sampleSections[targetSectionIndex]
        
        // `indexPath.row`가 섹션의 아이템 개수보다 작은지 확인 (배열 범위 초과 방지)
        guard indexPath.row < section.items.count else {
            fatalError("Index out of range for section items")
        }
        
        // 모델 데이터를 셀에 설정
        let data = section.items[indexPath.row]
        cell.configure(model: data)
        
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

//
//  PlaceDetailViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/5/25.
//

import UIKit

class PlaceDetailViewController: UIViewController {
    var targetSectionIndex: Int = 3 // 모델에서 원하는 인덱스 설정
    private var collectionHandler: PlaceDetailCollectionHandler?
    private let sampleSections = HotPlaceSectionModel.sampleSections
    private var detailData: HotPlaceDetailModel?
    private lazy var placeDetailView = PlaceDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = placeDetailView
        configureCollectionView()
        loadDetailData()
    }
    
    private func configureCollectionView() {
        collectionHandler = PlaceDetailCollectionHandler(
            targetSectionIndex: targetSectionIndex,
            sampleSections: sampleSections
        )
        placeDetailView.studyImageCollectionView.delegate = collectionHandler
        placeDetailView.studyImageCollectionView.dataSource = collectionHandler
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

extension PlaceDetailViewController: PlaceDetailViewGestureDelegate {
    func didTapFavoriteStar() {
        print("didTapFavoriteStar")
    }
    
    func didTapPlaceCreateButton() {
        print("didTapPlaceCreateButton")
    }
    
}

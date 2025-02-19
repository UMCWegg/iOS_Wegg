//
//  PlaceDetailViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/5/25.
//

import UIKit
import FloatingPanel

class PlaceDetailViewController: UIViewController {
    weak var mapVC: MapViewController?
    var targetSectionIndex: Int = 3 // 모델에서 원하는 인덱스 설정
    private var collectionHandler: PlaceDetailCollectionHandler?
    private let sampleSections = HotPlaceSectionModel.sampleSections
    private var detailData: HotPlaceDetailModel?
    lazy var placeDetailView = PlaceDetailView()
    
    init(mapVC: MapViewController?) { // 생성자에서 의존성 주입
        self.mapVC = mapVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        return HotPlaceDetailModel(phoneNumber: "1522-3232")
    }
    
    /**
     메인 스레드에서 UI를 업데이트하는 함수
     - Parameter detail: `HotPlaceDetailModel` 데이터
     */
    @MainActor
    private func updateUI(with detail: HotPlaceDetailModel) {
        detailData = detail
        
        print("Phone: \(detail.phoneNumber)")
        
        // TODO: [25.02.05] UI 업데이트 작업 - 작성자: 이재원
        let info = [
            placeDetailView.titleLabel: "스타벅스 신용산점",
            placeDetailView.categoryLabel: "카페",
            placeDetailView.verificationCount: "인증 99+",
            placeDetailView.saveCount: "저장 34",
            placeDetailView.addressLabel: "서울특별시 강남구 강남대로101길 101",
            placeDetailView.phoneNumberLabel: detail.phoneNumber,
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

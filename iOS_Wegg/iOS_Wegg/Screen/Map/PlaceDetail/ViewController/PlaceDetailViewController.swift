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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = placeDetailView
        loadDetailData()
    }
    
    lazy var placeDetailView = PlaceDetailView()
    
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

//
//  PlaceDetailViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/5/25.
//

import UIKit

class PlaceDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = PlaceDetailView()
        
        // 추후에 네비게이션 전환과 동시에 호출되는 곳에 위치시키기
        fetchDetail(for: "1") { detail in
            HotPlaceSectionModel.sampleSections[0].details = detail
        }
    }

    // 상세 데이터 로드 (장소 선택 시 호출)
    func fetchDetail(for placeID: String, completion: @escaping (HotPlaceDetailModel) -> Void) {
        // 예시 API 호출
        let detail = HotPlaceDetailModel(
            phoneNumber: "1522-3232",
            openingHours: "영업 중 · 매장 22:00에 영업 종료",
            websiteURL: "http://www.starbucks.co.kr/"
        )
        completion(detail)
    }
}

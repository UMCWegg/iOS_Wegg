//
//  AddScheduleViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/10/25.
//

import UIKit

protocol AddScheduleGestureDelegate: AnyObject {
    func didTapCalendarButton()
    func didTapDoneButton()
    func didTapCancelButton()
    func didChangeDate(_ date: Date)
}

class AddScheduleViewController: UIViewController {
    
    private var apiManager: APIManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        view = addScheduleView
        
        apiManager = APIManager()
        fetchSearchPlace(
            keyword: "스타벅스",
            at: Coordinate(latitude: 37.60635, longitude: 127.04425)
        )
    }
    
    lazy var addScheduleView = AddScheduleView().then {
        $0.gestureDelegate = self
    }
    
    /// 장소 검색 API 가져오는 함수
    /// - Parameters:
    ///     - keyword: 검색 키워드
    ///     - at: 장소 좌표
    ///     - page: 페이지
    ///     - pageSize: 페이지당 가져올 데이터 갯수
    private func fetchSearchPlace(
        keyword: String,
        at coordinate: Coordinate,
        page: Int = 0,
        pageSize: Int = 15
    ) {
        guard let apiManager = apiManager else { return }
        
        apiManager.setCookie(
            value: "871F290DD58CF91959E169A08F4B706D"
        )
        
        // 지도 경계 좌표 가져오기
        let request = ScheduleSearchRequest(
            keyword: keyword,
            latitude: String(coordinate.latitude),
            longitude: String(coordinate.longitude),
            page: page,
            size: pageSize
        )
        
        Task {
            do {
                let response: ScheduleSearchResponse = try await apiManager.request(
                    target: ScheduleAPI.searchPlace(request: request)
                )
                print(response.result.placeList)
            } catch {
                print("❌ 실패: \(error)")
            }
        }
    }

}

extension AddScheduleViewController: AddScheduleGestureDelegate {
    func didTapCalendarButton() {
        let scheduleCalendarVC = ScheduleCalendarViewController()
        scheduleCalendarVC.parentVC = self
        if let sheet = scheduleCalendarVC.sheetPresentationController {
            sheet.detents = [
                .custom(resolver: { context in
                // 화면 최대 높이의 66%
                return context.maximumDetentValue * 0.64
            })]
        }
        present(scheduleCalendarVC, animated: true)
    }
    
    func didTapDoneButton() {
        print("didTapDoneButton")
    }
    
    func didTapCancelButton() {
        print("didTapCancelButton")
    }
    
    func didChangeDate(_ date: Date) {
        print("didChangeDate")
    }
    
}

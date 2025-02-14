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

    override func viewDidLoad() {
        super.viewDidLoad()

        view = addScheduleView
        
        let apiManager = APIManager()
        
        apiManager.setCookie(
            value: "871F290DD58CF91959E169A08F4B706D"
        )
        
        // 지도 경계 좌표 가져오기
        let request = ScheduleSearchRequest(
            keyword: "스타벅스",
            latitude: "37.60635",
            longitude: "127.04425",
            page: 0,
            size: 15
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
    
    lazy var addScheduleView = AddScheduleView().then {
        $0.gestureDelegate = self
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

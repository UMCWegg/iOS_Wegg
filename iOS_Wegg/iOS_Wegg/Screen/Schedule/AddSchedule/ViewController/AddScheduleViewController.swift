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
    private var mapManager: MapManagerProtocol?
    private var addScheduleSearchTableHandler: AddScheduleSearchTableHandler?
    
    init(mapManager: MapManagerProtocol) {
        self.mapManager = mapManager
        super.init(nibName: nil, bundle: nil)
        self.addScheduleSearchTableHandler = AddScheduleSearchTableHandler(
            tableView: self.addScheduleView.searchResultListView.tableView
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = addScheduleView
        
        apiManager = APIManager()
    }
    
    lazy var addScheduleView = AddScheduleView().then {
        $0.gestureDelegate = self
        $0.placeSearchBar.delegate = self
        $0.searchResultListView.tableView.delegate = addScheduleSearchTableHandler
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

extension AddScheduleViewController: UISearchBarDelegate {
    
    /// 검색 내용 리턴
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        print("searchBarText: \(searchText)")
        searchBar.text = ""
    }
    
    /// 검색 내용 변화 리턴
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 실시간 검색
        print("현재 검색어: \(searchText)")
        // TODO: [25.02.15] 실제 현재 위치 mapManager 통해서 가져오기 - 작성자: 이재원
        let currentLocation: Coordinate = Coordinate(latitude: 37.60635, longitude: 127.04425)
        fetchSearchPlace(
            keyword: searchText,
            at: currentLocation
        )
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

//
//  AddScheduleViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/10/25.
//

import UIKit

enum TimePickertype {
    case startTime
    case finishTime
}

class AddScheduleViewController: UIViewController {
    
    private var apiManager: APIManager?
    private var mapManager: MapManagerProtocol?
    private var addScheduleSearchTableHandler = AddScheduleSearchTableHandler()
    private var selectedPlace: String?
    private var selectedStartTime: String?
    private var selectedFinishTime: String?
    private var selectedLateTime: LateStatus?
    var selectedFormmatedDates: [String] = [] // yyyy-MM-dd 형식의 날짜 배열
    
    init(mapManager: MapManagerProtocol) {
        self.mapManager = mapManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = addScheduleView
        
        apiManager = APIManager()
        setupTableHandler()
    }
    
    lazy var addScheduleView = AddScheduleView().then {
        $0.gestureDelegate = self
        $0.setDetailSettingCardDelegate(
            delegate: self,
            sendingDelegate: self
        )
        $0.placeSearchBar.delegate = self
        $0.searchResultListView.tableView.delegate = addScheduleSearchTableHandler
        // 뷰에서 만든 제스처의 딜리게이트를 컨트롤러에서 설정
        if let gestures = $0.gestureRecognizers {
            for gesture in gestures {
                if let tapGesture = gesture as? UITapGestureRecognizer {
                    tapGesture.delegate = self
                }
            }
        }
    }
    
    // MARK: - Set Up Functions
    
    private func setupTableHandler() {
        addScheduleSearchTableHandler.setupDataSource(
            for: addScheduleView.searchResultListView.tableView
        )
        // 선택한 장소 UI 업데이트
        addScheduleSearchTableHandler.didSelectPlace = { [weak self] place in
            self?.addScheduleView.updateSearchResultLabel(place, isHidden: false)
            self?.selectedPlace = place
        }
    }
    
    // MARK: - Public Functions
    
    public func setSelectedTime(type: TimePickertype, selectedTime: String) {
        switch type {
        case .startTime:
            selectedStartTime = selectedTime
        case .finishTime:
            selectedFinishTime = selectedTime
        }
    }
    
    // MARK: - API Functions
    
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
        
        apiManager.setCookie(value: CookieStorage.cookie)
        
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
                let placeList: [String] = response.result.placeList.map {
                    $0.placeName
                }
                addScheduleSearchTableHandler.updateSearchResults(placeList)
            } catch {
                print("❌ 실패: \(error)")
            }
        }
    }

}

// MARK: - Delegate Extension

extension AddScheduleViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        addScheduleView.toggleSearchResultList(false)
    }
    
    /// 검색 내용 리턴
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        addScheduleView.toggleSearchResultList(true)
    }
    
    /// 검색 내용 변화 리턴
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 실시간 검색
        addScheduleView.toggleSearchResultList(false)
        guard let mapManager = mapManager else { return }
        // 현재 위치 기반 장소 검색
        mapManager.getCurrentLocation { [weak self] coordinate in
            guard let currentLocation = coordinate else { return }
            if !searchText.isEmpty {
                // REFACT: API 호출 중복 개선하기 - 작성자: 이재원
                self?.fetchSearchPlace(
                    keyword: searchText,
                    at: currentLocation
                )
            } else {
                self?.addScheduleSearchTableHandler.updateSearchResults([])
                self?.addScheduleView.toggleSearchResultList(true)
            }
        }
        
    }
}

extension AddScheduleViewController:
    AddScheduleGestureDelegate,
    ScheduleDetailSettingViewDelegate {
    
    func didTapSaveButton() {
        guard let apiManager = apiManager,
            let selectedStartTime = selectedStartTime,
            let selectedFinishTime = selectedFinishTime,
            let selectedPlace = selectedPlace else { return }
        
        // 쿠키를 직접 저장
        apiManager.setCookie(value: CookieStorage.cookie)
        let request = AddScheduleRequest(
            status: .yet,
            planDates: selectedFormmatedDates,
            startTime: selectedStartTime,
            finishTime: selectedFinishTime,
            lateTime: selectedLateTime ?? .onTime,
            placeName: selectedPlace,
            planOn: true
        )
        
        Task {
            do {
                let response: AddScheduleResponse = try await apiManager.request(
                    target: ScheduleAPI.addSchedule(request: request)
                )
                let warningMessage = response.result.first?.warningMessage
                // 경고 메시지 존재할 경우 Alert 띄움
                if let warningMessage = warningMessage {
                    let confirmAction = UIAlertAction(title: "확인", style: .default)
                    let alert = UIAlertController(
                        title: "다시 작성해주세요!",
                        message: warningMessage,
                        preferredStyle: .alert
                    )
                    alert.addAction(confirmAction)
                    present(alert, animated: true)
                } else {
                    navigationController?.popViewController(animated: true)
                }
            } catch {
                print("❌ ScheduleAddResponse 실패: \(error)")
            }
        }
        
    }
    
    func didTapCancelButton() {
        navigationController?.popViewController(animated: true)
    }
    
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
    
    func didSelectStartTime() {
        showTimePicker(type: .startTime)
    }
    
    func didSelectFinishTime() {
        showTimePicker(type: .finishTime)
    }
    
    private func showTimePicker(type: TimePickertype) {
        let scheduleTimePicker = ScheduleTimeViewController()
        scheduleTimePicker.parentVC = self
        scheduleTimePicker.timePickerType = type
        if let sheet = scheduleTimePicker.sheetPresentationController {
            sheet.detents = [
                .custom(resolver: { context in
                    return context.maximumDetentValue * 0.64
                })]
        }
        present(scheduleTimePicker, animated: true)
    }
    
}

extension AddScheduleViewController: UIGestureRecognizerDelegate {
    // 특정 뷰(예: 검색 결과 테이블 뷰)를 탭할 때 키보드가 내려가지 않도록 예외 처리
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        if touch.view is UITableView {
            return false // 검색 결과 테이블 뷰를 탭할 경우 키보드 유지
        }
        return true
    }
}

extension AddScheduleViewController: ScheduleDetailViewSendingData {
    func sendSelectedLateStatus(_ status: LateStatus?) {
        selectedLateTime = status
    }
    
}

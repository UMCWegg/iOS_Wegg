//
//  ScheduleViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/20/25.
//

import UIKit

struct ScheduleModel: Hashable {
    let id: Int
    let date: String
    let location: String
    let timeRange: String
    var isOn: Bool
}

class ScheduleViewController:
    UIViewController,
    UIGestureRecognizerDelegate {
    
    private let apiManager = APIManager()
    private var mapManager: MapManagerProtocol?
    // UITableViewDiffableDataSource를 사용하여 데이터 관리
    private var dataSource: UITableViewDiffableDataSource<Int, ScheduleModel>?
    private var scheduleList: [ScheduleModel] = []
    
    // 의존성 주입
    init(mapManager: MapManagerProtocol) {
        self.mapManager = mapManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = scheduleView
        setupDataSource()
        // 임시 쿠키 설정
        apiManager.setCookie(value: CookieStorage.cookie)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 화면 전화시에도 호출되어 최신 일정으로 업데이트 됨
        fetchAllSchedules()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Navigation Bar 숨김. 다음 화면에서도 보이지 않음.
        navigationController?.setNavigationBarHidden(true, animated: animated)
        // 뒤로가기 제스처 활성화
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        // 현재 위치 초기화
        setupCurrentLocation()
    }

    lazy var scheduleView = ScheduleView().then {
        $0.studyCardTableView.delegate = self
        $0.gestureDelegate = self
    }
    
    private func setupCurrentLocation() {
        guard let mapManager = mapManager else { return }
        mapManager.setupLocationManager()
    }

    private func setupDataSource() {
        // Diffable Data Source를 생성하여 테이블 뷰에 연결
        dataSource = UITableViewDiffableDataSource<Int, ScheduleModel>(
            tableView: scheduleView.studyCardTableView
        ) { tableView, indexPath, schedule in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ScheduleCardCell.reuseIdentifier,
                for: indexPath
            ) as? ScheduleCardCell else {
                return UITableViewCell()
            }
            
            // 셀에 데이터 구성
            cell.configure(with: schedule)
            cell.delegate = self
            
            return cell
        }
    }

    private func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ScheduleModel>()
        snapshot.appendSections([0]) // 단일 섹션 추가
        snapshot.appendItems(scheduleList)
        // DataSource가 nil이 아닌 경우 스냅샷 적용
        guard let dataSource = dataSource else { return }
        dataSource.apply(snapshot, animatingDifferences: true)
        
//        // 현재 스냅샷 가져오기
//        let currentSnapshot = dataSource.snapshot()
//        // 스냅샷에서 모든 아이템 가져오기
//        print(currentSnapshot.itemIdentifiers)
    }
    
    private func fetchAllSchedules() {
        Task {
            do {
                let response: FetchAllSchedulesResponse = try await apiManager.request(
                    target: ScheduleAPI.fetchScheduleList
                )
                scheduleList = convertToScheduleModel(from: response.result)
                DispatchQueue.main.async { [weak self] in
                    self?.applyInitialSnapshot()
                }
            } catch {
                print("❌ ScheduleAddResponse 실패: \(error)")
            }
        }
    }
    
    /// ScheduleModel로 변환
    private func convertToScheduleModel(
        from scheduleList: [FetchAllSchedulesResponse.AllSchedulesResult]
    ) -> [ScheduleModel] {
        return scheduleList.map { schedule in
            ScheduleModel(
                id: schedule.planId,
                date: schedule.startTime,
                location: schedule.address,
                timeRange: schedule.startTime + schedule.finishTime,
                isOn: true
            )
        }
    }
    
    /// 삭제 API 호출 및 UI 업데이트
    private func deleteSchedule(_ schedule: ScheduleModel) {
        Task {
            do {
                let response: DeleteScheduleResponse = try await apiManager.request(
                    target: ScheduleAPI.deleteSchedule(planId: schedule.id)
                )
                
                if response.isSuccess {
                    DispatchQueue.main.async { [weak self] in
                        self?.scheduleList.removeAll { $0.id == schedule.id } // 로컬 데이터 삭제
                        self?.applyInitialSnapshot() // UI 업데이트
                    }
                } else {
                    print("일정 삭제 실패")
                }
            } catch {
                print("DeleteScheduleResponse 오류: \(error)")
            }
        }
    }
}

extension ScheduleViewController: UITableViewDelegate {
    /*
    // 셀 선택 시 호출되는 메서드
    // 현재 주석 처리: 필요 시 활성화
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let dataSource = dataSource else { return }
        guard let selectedItem = dataSource.itemIdentifier(
            for: indexPath
        ) else { return }
        print("선택된 항목: \(selectedItem.location)")
    }
    */
    
    // 스와이프 삭제 기능 추가
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        // 삭제 액션 정의
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "삭제"
        ) { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            
            let scheduleToDelete = scheduleList[indexPath.row]
            self.deleteSchedule(scheduleToDelete)
            
            completionHandler(true) // 액션 완료 처리
        }
        
        deleteAction.backgroundColor = .systemRed // 삭제 버튼 색상
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // 각 셀의 높이를 설정하는 메서드
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138 // 셀 높이를 138로 고정
    }
}

extension ScheduleViewController: ScheduleViewGestureDelegate {
    func didTapAddScheduleButton() {
        guard let mapManager = mapManager else { return }
        let addScheduleVC = AddScheduleViewController(mapManager: mapManager)
        addScheduleVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(addScheduleVC, animated: true)
    }
    
}

extension ScheduleViewController: ScheduleCardCellDelegate {
    /// `UISwitch`가 속한 `ScheduleCardCell`을 찾는 함수
    private func findParentCell<T: UITableViewCell>(
        for view: UIView,
        ofType cellType: T.Type
    ) -> T? {
        var superview = view.superview
        while let view = superview {
            if let cell = view as? T {
                return cell
            }
            superview = view.superview
        }
        return nil
    }
    
    func toggleSwitchAlarm(action: UIAction) {
        guard let toggle = action.sender as? UISwitch else { return }
        
        // `superview`를 탐색하여 `ScheduleCardCell` 찾기
        guard let cell = findParentCell(for: toggle, ofType: ScheduleCardCell.self) else {
            print("❌ ScheduleCardCell을 찾을 수 없음")
            return
        }
        
        guard let indexPath = scheduleView
            .studyCardTableView.indexPath(for: cell) else {
            print("indexPath 찾을 수 없음")
            return
        }
        
        guard let selectedSchedule = dataSource?.itemIdentifier(for: indexPath) else {
            print("선택된 일정을 찾을 수 없음")
            return
        }
        
        let planId: Int = selectedSchedule.id
        
        var request: OnOffScheduleRequest = toggle.isOn
            ? OnOffScheduleRequest(planOn: .on)
            : OnOffScheduleRequest(planOn: .off)
        
        print("선택된 일정: \(selectedSchedule)")
        
        Task {
            do {
                let response: OnOffScheduleResponse = try await apiManager.request(
                    target: ScheduleAPI.onOffSchedule(planId: planId, request: request)
                )
                print("response: \(response)")
            } catch {
                print("DeleteScheduleResponse 오류: \(error)")
            }
        }
    }
}

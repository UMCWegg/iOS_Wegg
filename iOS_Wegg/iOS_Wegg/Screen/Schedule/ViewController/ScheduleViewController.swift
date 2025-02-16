//
//  ScheduleViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/20/25.
//

import UIKit

struct Schedule: Hashable {
    let id: UUID
    let date: String
    let location: String
    let timeRange: String
    var isOn: Bool
}

class ScheduleViewController:
    UIViewController,
    UIGestureRecognizerDelegate {
    
    private var mapManager: MapManagerProtocol?
    // UITableViewDiffableDataSource를 사용하여 데이터 관리
    private var dataSource: UITableViewDiffableDataSource<Int, Schedule>?
    
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
        applyInitialSnapshot()
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
        dataSource = UITableViewDiffableDataSource<Int, Schedule>(
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
            return cell
        }
    }

    private func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Schedule>()
        snapshot.appendSections([0]) // 단일 섹션 추가
        snapshot.appendItems([
            Schedule(
                id: UUID(),
                date: "1월 14일",
                location: "스타벅스 미아점",
                timeRange: "9:00 AM ~ 12:00 PM",
                isOn: true
            ),
            Schedule(
                id: UUID(),
                date: "1월 15일",
                location: "투썸플레이스 강남점",
                timeRange: "10:00 AM ~ 1:00 PM",
                isOn: false
            )
        ])
        // DataSource가 nil이 아닌 경우 스냅샷 적용
        guard let dataSource = dataSource else { return }
        dataSource.apply(snapshot, animatingDifferences: true)
        
//        // 현재 스냅샷 가져오기
//        let currentSnapshot = dataSource.snapshot()
//        // 스냅샷에서 모든 아이템 가져오기
//        print(currentSnapshot.itemIdentifiers)
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

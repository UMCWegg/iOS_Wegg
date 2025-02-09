//
//  ScheduleViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/20/25.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    private var dataSource: UITableViewDiffableDataSource<Int, Schedule>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = scheduleView
        setupDataSource()
        applyInitialSnapshot()
    }

    lazy var scheduleView = ScheduleView().then {
        $0.studyCardTableView.delegate = self
    }

    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Schedule>(
            tableView: scheduleView.studyCardTableView
        ) { tableView, indexPath, schedule in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ScheduleCardCell.reuseIdentifier,
                for: indexPath
            ) as? ScheduleCardCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: schedule)
            return cell
        }
    }

    private func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Schedule>()
        snapshot.appendSections([0])
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
        guard let dataSource = dataSource else { return }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func toggleScheduleState(schedule: Schedule) {
        guard let dataSource = dataSource else { return }
        var snapshot = dataSource.snapshot()
        guard let index = snapshot.indexOfItem(schedule) else { return }
        
        var updatedSchedule = schedule
        updatedSchedule.isOn.toggle()
        
        snapshot.insertItems([updatedSchedule], beforeItem: snapshot.itemIdentifiers[index])
        snapshot.deleteItems([schedule])
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}

extension ScheduleViewController: UITableViewDelegate {
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
    
    // 셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
    }
}

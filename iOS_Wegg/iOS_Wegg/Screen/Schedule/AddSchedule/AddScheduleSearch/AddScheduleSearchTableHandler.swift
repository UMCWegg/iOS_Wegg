//
//  AddScheduleSearchTableHandler.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/15/25.
//

import UIKit

class AddScheduleSearchTableHandler:
    NSObject,
    UITableViewDelegate {
    
    private var dataSource: UITableViewDiffableDataSource<Int, String>?
    private var tableView: UITableView?
    private var placeList: [String] = [
        "스타벅스 월곡역점",
        "스타벅스 종암점"
    ]
    
    init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        setupDataSource()
        applayInitialSnapshot()
    }
    
    private func setupDataSource() {
        guard let tableView = tableView else {
            print("tableView is nil")
            return
        }
        dataSource = UITableViewDiffableDataSource<Int, String>(
            tableView: tableView
        ) { tableView, indexPath, placeName in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: AddScheduleSearchTableCell.reuseIdentifier,
                for: indexPath
            ) as? AddScheduleSearchTableCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: placeName)
            return cell
        }
    }
    
    private func applayInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(placeList)
        guard let dataSource = dataSource else {
            return
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - UITableViewDelegate
    
    // 각 셀의 높이를 설정하는 메서드
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20 // 셀 높이 고정
    }
}

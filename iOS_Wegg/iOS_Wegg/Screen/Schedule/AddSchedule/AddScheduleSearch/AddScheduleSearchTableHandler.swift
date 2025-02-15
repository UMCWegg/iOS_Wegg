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

    /// 데이터 소스를 설정하는 함수
    func setupDataSource(for tableView: UITableView) {
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

    /// 검색 결과를 업데이트하는 함수
    /// - Parameters:
    ///     - _ result: api 호출 응답 배열
    func updateSearchResults(_ results: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(results)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 // 셀 높이 설정
    }
}

//
//  MapSearchTableHandler.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/19/25.
//

import UIKit

class MapSearchTableHandler: NSObject, UITableViewDelegate {
    var didSelectPlace: ((String) -> Void)?
    
    private var dataSource: UITableViewDiffableDataSource<Int, String>?

    /// 데이터 소스를 설정하는 함수
    func setupDataSource(for tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource<Int, String>(
            tableView: tableView
        ) { tableView, indexPath, placeName in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MapSearchTableCell.reuseIdentifier,
                for: indexPath
            ) as? MapSearchTableCell else {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택한 셀 아이템 가져오기
        if let item = dataSource?.itemIdentifier(for: indexPath) {
            didSelectPlace?(item)
        }
    }
}

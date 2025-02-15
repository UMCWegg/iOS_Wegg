//
//  AddScheduleSearchListView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/15/25.
//

import UIKit
import Then
import SnapKit

class AddScheduleSearchListView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView = UITableView(
        frame: .zero,
        style: .plain
    ).then {
        $0.register(
            AddScheduleSearchTableViewCell.self,
            forCellReuseIdentifier: AddScheduleSearchTableViewCell.reuseIdentifier)
        $0.separatorStyle = .none
        $0.rowHeight = 60
        $0.backgroundColor = .white
    }
}

private extension AddScheduleSearchListView {
    func setupView() {
        addComponents()
        constraints()
    }
    
    func addComponents() {
        addSubview(tableView)
    }
    
    func constraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

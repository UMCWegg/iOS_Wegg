//
//  SearchResultView.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/18/25.
//

import UIKit

class SearchResultView: UIView {
    let tableView = UITableView().then {
        $0.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

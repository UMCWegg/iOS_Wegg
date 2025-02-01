//
//  NotiView.swift
//  iOS_Wegg
//
//  Created by KKM on 1/31/25.
//

import UIKit
import SnapKit
import Then

class NotiView: UIView {

    let notiFollowView = NotiFollowView()
    
    let tableView = UITableView().then {
        $0.register(NotiCell.self, forCellReuseIdentifier: NotiCell.identifier)
        $0.separatorStyle = .none
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .white
        addSubview(notiFollowView)
        addSubview(tableView)

        notiFollowView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(21)
            $0.leading.trailing.equalToSuperview().inset(21.5) // leading과 trailing을 동시에 설정하여 너비를 조정
            $0.height.equalTo(46)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(notiFollowView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

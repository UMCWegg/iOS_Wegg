//
//  SearchResultView.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/18/25.
//

import UIKit

class SearchResultView: UIView {
    
    /// 테이블 뷰. ㅓㄴ언
    let tableView = UITableView().then {
        $0.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
    }
    
    /// 검색 필터 밑의 최근 검색어 라벨
    let recentSearchLabel = UILabel().then {
        $0.text = "최근 검색"
        $0.font = UIFont.notoSans(.bold, size: 16)
        $0.textColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(recentSearchLabel)
        addSubview(tableView)
        
        // 최근 검색어 라벨 설정 (테이블뷰 위에 위치)
        recentSearchLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)   // 상단 여백
            make.left.equalToSuperview().offset(16) // 왼쪽 여백
            make.right.equalToSuperview().offset(-16) // 오른쪽 여백
            make.height.equalTo(30)                 // 라벨 높이
        }
        
        // 테이블뷰 설정 (라벨 아래에 위치)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchLabel.snp.bottom).offset(8) // 라벨 아래로 8pt 간격
            make.left.right.bottom.equalToSuperview() 
        }
    }
}

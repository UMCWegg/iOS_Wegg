//
//  SearchBarView.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/18/25.
//

import UIKit
import Then

class SearchBarView: UIView {

    let searchBar = UISearchBar().then {
        $0.placeholder = "계정 검색"
        $0.backgroundImage = UIImage()
        $0.searchTextField.backgroundColor = .white
        $0.searchTextField.borderStyle = .roundedRect
        $0.searchTextField.textColor = .black
        
        // 🔹 기본 왼쪽 돋보기 제거
        $0.searchTextField.leftView = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

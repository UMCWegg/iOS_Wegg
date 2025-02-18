//
//  SearchBarView.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/18/25.
//

import UIKit

class SearchBarView: UIView {
    let searchBar = UISearchBar().then {
        $0.placeholder = "계정 검색"
        $0.backgroundImage = UIImage()
        $0.searchTextField.backgroundColor = .white
        $0.searchTextField.borderStyle = .roundedRect
        $0.searchTextField.textColor = .black
        
        // 🔹 기본 왼쪽 돋보기 제거
        $0.searchTextField.leftView = nil
        
        // 🔹 오른쪽에 커스텀 돋보기 아이콘 추가
        let searchIcon = UIImageView(image: UIImage(named: "search_black"))
        searchIcon.contentMode = .center
        
        // 🔹 아이콘 크기 및 여백 설정
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        iconContainer.addSubview(searchIcon)
        searchIcon.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        
        // 🔹 오른쪽 뷰로 설정
        $0.searchTextField.rightView = iconContainer
        $0.searchTextField.rightViewMode = .always
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

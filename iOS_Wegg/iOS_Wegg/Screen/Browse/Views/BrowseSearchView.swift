//
//  SearchView.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/20/25.
//

import UIKit
import SnapKit

class BrowseSearchView: UIView, UISearchBarDelegate {
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .yellowWhite
        addComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    /// 검색 바와 아이콘을 포함하는 컨테이너 뷰
    private let searchContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.customColor(.secondary).cgColor
    }
    
    /// 검색바 (검색 텍스트 입력 필드)
    public lazy var searchBar = UISearchBar().then {
        $0.placeholder = "계정 검색"
        $0.backgroundImage = UIImage()
        $0.delegate = self
        $0.searchTextField.backgroundColor = .white
        $0.searchTextField.borderStyle = .none
        $0.searchTextField.textColor = .black
        $0.searchTextField.leftView = nil
    }
    
    /// 돋보기 아이콘 (검색 아이콘 역할)
    private let searchIconView = UIImageView().then {
        $0.image = UIImage(named: "search")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .gray
    }
    
    // MARK: - Methods
    
    /// UI 구성 요소 추가
    private func addComponents() {
        self.addSubview(searchContainerView)
        searchContainerView.addSubview(searchBar)
        searchContainerView.addSubview(searchIconView)
    }
    
    /// UI 제약 조건 설정
    private func setupConstraints() {
        searchContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(45)
        }
        
        searchBar.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.right.equalTo(searchIconView.snp.left).offset(-10)
            $0.top.bottom.equalToSuperview()
        }
        
        searchIconView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24) // 아이콘 크기 조정
        }
    }
}

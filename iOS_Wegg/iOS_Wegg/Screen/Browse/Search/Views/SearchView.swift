//
//  SearchView.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/20/25.
//

import UIKit

class SearchView: UIView, UISearchBarDelegate {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addComponents()
        constraints()
        changeCancelKorean()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property
    
    /// 검색바 UI
    public lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "계정 검색"
        searchBar.barTintColor = .white
        searchBar.backgroundColor = .clear
        searchBar.showsCancelButton = true
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        /* 돋보기 아이콘 및 여백 제거 */
        searchBar.searchTextField.leftView = nil
        
        return searchBar
    }()
    
    // MARK: - Methods
    
    /// 기본적으로 검색바를 만들면 취소 버튼이 아닌, cancel이라고 영어로 칭해져서 등장한다. 이를 취소 버튼으로 재생성
    private func changeCancelKorean() {
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle("취소", for: .normal)
        }
    }
 
    /// 제약조건 및 컴포넌트 추가
    private func addComponents() {
        [searchBar].forEach { self.addSubview($0) }
    }
    
    private func constraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
    }
}

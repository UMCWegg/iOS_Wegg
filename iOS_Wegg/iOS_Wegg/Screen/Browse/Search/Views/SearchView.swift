//
//  SearchView.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/18/25.
//
import UIKit
import SnapKit

class SearchView: UIView {

    // MARK: - Properties
    let searchBarView = SearchBarView()
    let searchResultView = SearchResultView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    /// View 계층 설정
    private func setupView() {
        addSubview(searchBarView)
        addSubview(searchResultView)
    }

    /// UI 제약 조건 설정
    private func setupConstraints() {
        searchBarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }

        searchResultView.snp.makeConstraints { make in
            make.top.equalTo(searchBarView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

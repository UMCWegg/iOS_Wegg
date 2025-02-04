//
//  MapSearchBarView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/4/25.
//

import UIKit
import SnapKit
import Then

protocol MapSearchBarDelegate: AnyObject {
    func mapSearchBarDidTapBackButton()
    func mapsearchBarDidTapSearchButton(query: String?)
}

class MapSearchBar: UIView {

    // MARK: - Delegate
    weak var delegate: MapSearchBarDelegate?

    // MARK: - UI Components
    lazy var searchTextFieldView = UITextField().then {
        $0.textColor = .black
        $0.placeholder = "Search..."
        $0.clearButtonMode = .always // 입력내용 한번에 지우는 x버튼(오른쪽)
        $0.clearsOnBeginEditing = false // 편집 시 기존 텍스트필드값 제거
    }

    lazy var searchBackButtonView = UIButton().then {
        $0.setImage(UIImage(named: "searchBackButton"), for: .normal)
        $0.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }

    lazy var searchButtonView = UIButton().then {
        $0.setImage(UIImage(named: "MapSearchButton"), for: .normal)
        $0.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
    }

    lazy var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill
        $0.addArrangedSubview(searchBackButtonView)
        $0.addArrangedSubview(searchTextFieldView)
        $0.addArrangedSubview(searchButtonView)
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        constraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    @objc private func didTapBackButton() {
        delegate?.mapSearchBarDidTapBackButton()
    }

    @objc private func didTapSearchButton() {
        let query = searchTextFieldView.text
        delegate?.mapsearchBarDidTapSearchButton(query: query)
    }

    // MARK: - Setup
    private func setupView() {
        addSubview(stackView)
    }

    private func constraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        searchBackButtonView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }

        searchButtonView.snp.makeConstraints { make in
            make.width.height.equalTo(28)
        }
    }
}

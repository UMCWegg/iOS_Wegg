//
//  MapSearchBarView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/4/25.
//

import UIKit
import SnapKit
import Then

/// `MapSearchBar`에서 발생하는 상호작용을 처리하기 위한 Delegate 프로토콜.
protocol MapSearchBarDelegate: AnyObject {
    /// 뒤로가기 버튼이 눌렸을 때 호출.
    func didTapSearchBackButton()

    /// 검색이 실행되었을 때 호출됩니다. 입력된 검색어를 전달.
    func didSearch(query: String?)

    /// 검색 상자를 탭하거나 편집을 시작했을 때 호출.
    func didTapSearchBox()
}

///  설명:
///  - 뒤로가기 버튼, 검색 입력 필드, 검색 버튼을 포함한 커스텀 검색 바.
///  - 버튼 클릭, 검색 입력 상호작용 등의 이벤트를 `MapSearchBarDelegate`를 통해 위임.
class MapSearchBar: UIView {

    // MARK: - Delegate
    weak var delegate: MapSearchBarDelegate?

    // MARK: - UI Components
    
    lazy var searchTextFieldView = UITextField().then {
        $0.textColor = .black
        $0.placeholder = "Search..."
        $0.clearButtonMode = .always // 입력내용 한번에 지우는 x버튼(오른쪽)
        $0.clearsOnBeginEditing = false // 편집 시 기존 텍스트필드값 제거
        $0.delegate = self
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
        delegate?.didTapSearchBackButton()
    }

    @objc private func didTapSearchButton() {
        let query = searchTextFieldView.text
        delegate?.didSearch(query: query)
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

// MARK: - UITextFieldDelegate

extension MapSearchBar: UITextFieldDelegate {
    // 탭하여 편집을 시작할 때 호출
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.didTapSearchBox()
    }
    
    // 엔터(Return 키) 누를 때 호출되는 함수(검색 결과 처리)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text,
              !query.isEmpty else {
            return false
        }
        
        delegate?.didSearch(query: query)
        
        return true
    }
}

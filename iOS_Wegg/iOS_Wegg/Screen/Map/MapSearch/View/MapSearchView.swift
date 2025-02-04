//
//  MapSearchView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/3/25.
//

import UIKit
import Then

class MapSearchView: UIView {
    
    weak var gestureDelegte: MapSearchViewGestureDelegate?
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property
    
    lazy var searchTextFieldView = UITextField().then {
        $0.textColor = .black
        $0.placeholder = "Search..."
        $0.clearButtonMode = .always // 입력내용 한번에 지우는 x버튼(오른쪽)
        $0.clearsOnBeginEditing = false // 편집 시 기존 텍스트필드값 제거
    }
    
    lazy var searchBackButtonView = makeButtonView(imageName: "searchBackButton")
    lazy var searchButtonView = makeButtonView(imageName: "MapSearchButton")
    lazy var searchBarStack = makeStackView(spacing: 8, axis: .horizontal)
    
    // MARK: - Function
    
    func makeStackView(
        spacing: CGFloat,
        axis: NSLayoutConstraint.Axis
    ) -> UIStackView {
        let stack = UIStackView()
        stack.axis = axis
        stack.spacing = spacing
        stack.distribution = .fill
        
        return stack
    }
    
    func makeButtonView(imageName: String) -> UIButton {
        let button = UIButton()
        let image = UIImage(named: imageName)
        image?.withTintColor(.black, renderingMode: .alwaysTemplate)
        button.setImage(image, for: .normal)
        
        return button
    }
    
    @objc func searchButtonTapped() {
        gestureDelegte?.didTapSearchButton()
    }
    
    @objc func searchBackButtonTapped() {
        gestureDelegte?.didTapSearchBackButton()
    }
    
}

// MARK: - Setup Extension

private extension MapSearchView {
    func setupView() {
        setupGestures()
        setupStackView()
        addComponenets()
        constraints()
    }
    
    func setupGestures() {
        searchBackButtonView.addTarget(
            self,
            action: #selector(searchBackButtonTapped),
            for: .touchUpInside
        )
        
        searchButtonView.addTarget(
            self,
            action: #selector(searchButtonTapped),
            for: .touchUpInside
        )
    }
    
    func setupStackView() {
        [
            searchBackButtonView,
            searchTextFieldView,
            searchButtonView
        ].forEach {
            searchBarStack.addArrangedSubview($0)
        }
        
        searchBackButtonView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        
        searchTextFieldView.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(303)
            make.height.equalToSuperview()
        }
        
        searchButtonView.snp.makeConstraints { make in
            make.width.height.equalTo(28)
        }
    }
    
    func addComponenets() {
        [searchBarStack].forEach {
            addSubview($0)
        }
    }
    
    func constraints() {
        searchBarStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.greaterThanOrEqualTo(50)
        }
    }
}

//
//  ScheduleView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/10/25.
//

import UIKit
import Then

protocol ScheduleViewGestureDelegate: AnyObject {
    func didTapAddScheduleButton()
}

class ScheduleView: UIView {
    
    weak var gestureDelegate: ScheduleViewGestureDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellowWhite
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var editLabel = makeLabel(
        "편집",
        .notoSans(.medium, size: 16),
        .primary
    )
    
    lazy var createEggLabel = makeLabel(
        "create egg",
        .notoSans(.medium, size: 16),
        .customGray
    ).then {
        $0.textAlignment = .center
    }
    
    lazy var addScheduleImageButton = makeImageView(
        "AddSchedule",
        contentMode: .scaleAspectFit
    ).then {
        $0.isUserInteractionEnabled = true
    }
    
    private lazy var headerStackView = makeStackView(90, .horizontal)
    
    lazy var studyCardTableView = UITableView().then {
        $0.register(
            ScheduleCardCell.self,
            forCellReuseIdentifier: ScheduleCardCell.reuseIdentifier
        )
        $0.separatorStyle = .none
        $0.backgroundColor = .yellowWhite
    }
    
    // MARK: - Utility Functions
    
    /// UILabel 생성 함수
    func makeLabel(
        _ title: String = "",
        _ font: UIFont?,
        _ color: UIColor
    ) -> UILabel {
        return UILabel().then {
            $0.text = title
            $0.font = font ?? UIFont.systemFont(ofSize: 19, weight: .medium)
            $0.textColor = color
            $0.textAlignment = .left
        }
    }

    /// UIImageView 생성 함수
    func makeImageView(
        _ imageName: String,
        contentMode: UIView.ContentMode = .scaleAspectFill
    ) -> UIImageView {
        return UIImageView().then {
            $0.image = UIImage(named: imageName)
            $0.contentMode = contentMode
        }
    }

    /// UIStackView 생성 함수
    func makeStackView(
        _ spacing: CGFloat,
        _ axis: NSLayoutConstraint.Axis,
        _ distribution: UIStackView.Distribution = .fill
    ) -> UIStackView {
        return UIStackView().then {
            $0.axis = axis
            $0.spacing = spacing
            $0.distribution = distribution
        }
    }
    
    // MARK: - Handler
    
    @objc private func handleAddScheduleImageButton() {
        gestureDelegate?.didTapAddScheduleButton()
    }
}

// MARK: - Set Up Extension

private extension ScheduleView {
    func setupView() {
        setupStackView()
        setupGestures()
        addComponents()
        constraints()
    }
    
    func setupGestures() {
        let addButtonTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleAddScheduleImageButton)
        )
        addScheduleImageButton.addGestureRecognizer(addButtonTapGesture)
    }
    
    func setupStackView() {
        [
            editLabel,
            createEggLabel,
            addScheduleImageButton
        ].forEach {
            headerStackView.addArrangedSubview($0)
        }
        
    }
    
    func addComponents() {
        [
            headerStackView,
            studyCardTableView
        ].forEach(addSubview)
        
        editLabel.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
        
        createEggLabel.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
        
        addScheduleImageButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
    }
    
    func constraints() {
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(30)
        }
        
        studyCardTableView.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

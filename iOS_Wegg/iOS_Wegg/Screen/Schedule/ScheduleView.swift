//
//  ScheduleView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/10/25.
//

import UIKit

class ScheduleView: UIView {

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
    )
    
    lazy var addScheduleImageButton = makeImageView(
        "AddSchedule",
        contentMode: .scaleAspectFit
    )
    
    private lazy var headerStackView = makeStackView(108, .horizontal)
    
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
}

// MARK: - Set Up Extension

private extension ScheduleView {
    func setupView() {
        setupStackView()
        addComponents()
        constraints()
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
        [headerStackView].forEach(addSubview)
        
        addScheduleImageButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
    }
    
    func constraints() {
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.lessThanOrEqualToSuperview().inset(21)
            make.height.equalTo(30)
        }
    }
}

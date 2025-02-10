//
//  AddScheduleView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/10/25.
//

import UIKit
import Then

class AddScheduleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellowWhite
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property
    
    // REFACTOR: cancelLabel,createEggLabel, saveLabel 중복 - 작성자: 이재원
    lazy var cancelLabel = makeLabel(
        "취소",
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
    
    lazy var saveLabel = makeLabel(
        "저장",
        .notoSans(.medium, size: 16),
        .primary
    )
    
    private lazy var headerStackView = makeStackView(90, .horizontal)
    
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

private extension AddScheduleView {
    func setupView() {
        setupStackView()
        setupGestures()
        addComponents()
        constraints()
    }
    
    func setupGestures() {
        
    }
    
    func setupStackView() {
        [
            cancelLabel,
            createEggLabel,
            saveLabel
        ].forEach {
            headerStackView.addArrangedSubview($0)
        }
        
    }
    
    func addComponents() {
        [
            headerStackView
        ].forEach(addSubview)
        
        createEggLabel.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
        
        [cancelLabel, saveLabel].forEach { label in
            label.snp.makeConstraints { make in
                make.width.equalTo(30)
            }
        }
        
    }
    
    func constraints() {
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(30)
        }
    }
}

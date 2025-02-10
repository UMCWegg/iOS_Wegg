//
//  AddScheduleView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/10/25.
//

import UIKit
import Then

class AddScheduleView: UIView {
    
    weak var gestureDelegate: AddScheduleGestureDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellowWhite
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property
    
    private lazy var headerStackView = makeStackView(90, .horizontal)
    
    private lazy var cancelLabel = makeLabel("취소", .notoSans(.medium, size: 16), .primary)
    private lazy var createEggLabel = makeLabel(
        "create egg",
        .notoSans(.medium, size: 16),
        .customGray
    ).then {
        $0.textAlignment = .left
    }
    private lazy var saveLabel = makeLabel(
        "저장",
        .notoSans(.medium, size: 16),
        .primary
    )
    
    private lazy var placeSettingLabel = makeLabel(
        "장소 설정",
        .notoSans(.medium, size: 15),
        .customGray
    )
    
    lazy var placeSearchBar = UISearchBar().then {
        $0.placeholder = "지명, 도로명, 건물명으로 검색"
        $0.barTintColor = .white
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.secondary.cgColor
        $0.backgroundImage = UIImage()
        $0.searchTextField.backgroundColor = .clear
        $0.searchTextField.layer.cornerRadius = 12
        $0.searchTextField.layer.masksToBounds = true
    }

    private lazy var createPlaceImageView = makeImageView(
        "CreatePlace",
        contentMode: .scaleAspectFit
    )

    private lazy var yellowLogoIcon = makeImageView("yellow_wegg_icon").then {
        $0.layer.shadowColor = UIColor.secondary.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.shadowRadius = 2.5
        $0.layer.shadowOpacity = 0.2
    }

    private lazy var detailSettingLabel = makeLabel(
        "세부 설정",
        .notoSans(.medium, size: 15)
        , .customGray
    )

    private lazy var detailSettingCardView = makeCardView()

    private lazy var dateLabel = makeLabel("날짜", .notoSans(.medium, size: 16), .customGray)
    private lazy var calenderImageButton = makeImageButton("calendar")

    private lazy var randomVerificationLabel = makeLabel(
        "랜덤 인증",
        .notoSans(.medium, size: 16),
        .customGray
    )

    private lazy var timeRangeButton = makeButton(
        "00:00     ~    00:00",
        color: .gray1
    ).then {
        $0.contentHorizontalAlignment = .right // 우측 정렬
    }

    private lazy var lateAllowanceLabel = makeLabel(
        "지각 허용",
        .notoSans(.medium, size: 16),
        .customGray
    )
    private lazy var toggleSwitch = UISwitch().then { $0.onTintColor = .primary }

    private lazy var dividedLine = makeDivider()
    private lazy var dividedLine2 = makeDivider()

    // MARK: - Utility Functions

    private func makeLabel(
        _ title: String,
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

    private func makeImageView(
        _ imageName: String,
        contentMode: UIView.ContentMode = .scaleAspectFill
    ) -> UIImageView {
        return UIImageView().then {
            $0.image = UIImage(named: imageName)
            $0.contentMode = contentMode
        }
    }

    private func makeStackView(
        _ spacing: CGFloat,
        _ axis: NSLayoutConstraint.Axis
    ) -> UIStackView {
        return UIStackView().then {
            $0.axis = axis
            $0.spacing = spacing
            $0.distribution = .fill
        }
    }

    private func makeButton(
        _ title: String,
        color: UIColor
    ) -> UIButton {
        return UIButton().then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(color, for: .normal)
            $0.titleLabel?.font = .notoSans(.medium, size: 16)
        }
    }
    
    private func makeImageButton(
        _ imageName: String
    ) -> UIButton {
        return UIButton().then {
            $0.setImage(UIImage(named: imageName), for: .normal)
        }
    }

    private func makeDivider() -> UIView {
        return UIView().then {
            $0.backgroundColor = .customGray2
            $0.snp.makeConstraints { make in make.height.equalTo(1) }
        }
    }
    
    private func makeCardView() -> UIView {
        return UIView().then {
            $0.backgroundColor = .white
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.secondaryLabel.cgColor
            $0.layer.cornerRadius = 25
        }
    }
    
    // MARK: - Action Handler
    
    @objc private func handleCalendarButton() {
        gestureDelegate?.didTapCalendarButton()
    }
    
    @objc private func handleDoneButton() {
        gestureDelegate?.didTapDoneButton()
    }
    
    @objc private func handleCancelButton() {
        gestureDelegate?.didTapCancelButton()
    }
    
    @objc private func handleChangeDateButton() {
        gestureDelegate?.didChangeDate(Date())
    }
}

// MARK: - Setup UI

private extension AddScheduleView {
    func setupView() {
        setupStackView()
        setupGestures()
        addComponents()
        constraints()
        constraintsDetailSettingView()
    }
    
    func setupGestures() {
        calenderImageButton.addTarget(
            self,
            action: #selector(handleCalendarButton),
            for: .touchUpInside
        )
        timeRangeButton.addTarget(
            self,
            action: #selector(handleChangeDateButton),
            for: .touchUpInside
        )
    }
    
    func setupStackView() {
        [cancelLabel, createEggLabel, saveLabel].forEach { headerStackView.addArrangedSubview($0) }
    }
    
    func addComponents() {
        [
            headerStackView,
            placeSettingLabel,
            placeSearchBar,
            createPlaceImageView,
            yellowLogoIcon,
            detailSettingLabel,
            detailSettingCardView
        ].forEach(addSubview)

        [
            dateLabel,
            calenderImageButton,
            dividedLine,
            randomVerificationLabel,
            timeRangeButton,
            dividedLine2,
            lateAllowanceLabel,
            toggleSwitch
        ].forEach(detailSettingCardView.addSubview)
    }
    
    func constraints() {
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(30)
        }
        
        placeSettingLabel.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(18)
            make.leading.equalToSuperview().offset(21)
        }
        
        placeSearchBar.snp.makeConstraints { make in
            make.top.equalTo(placeSettingLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(44)
        }
        
        createPlaceImageView.snp.makeConstraints { make in
            make.top.equalTo(placeSearchBar.snp.bottom).offset(14)
            make.leading.equalTo(placeSearchBar.snp.leading)
            make.trailing.equalTo(placeSearchBar.snp.trailing)
            make.height.equalTo(120)
        }
        
        yellowLogoIcon.snp.makeConstraints { make in
            make.center.equalTo(createPlaceImageView)
            make.width.height.equalTo(20)
        }
        
        detailSettingLabel.snp.makeConstraints { make in
            make.top.equalTo(createPlaceImageView.snp.bottom).offset(20)
            make.leading.equalTo(placeSearchBar.snp.leading)
            make.trailing.equalTo(placeSearchBar.snp.trailing)
            make.width.equalTo(50)
        }
        
        detailSettingCardView.snp.makeConstraints { make in
            make.top.equalTo(detailSettingLabel.snp.bottom).offset(14)
            make.leading.equalTo(placeSearchBar.snp.leading)
            make.trailing.equalTo(placeSearchBar.snp.trailing)
            make.height.equalTo(174)
        }
        
    }
    
    func constraintsDetailSettingView() {
        let sideInset: CGFloat = 17
        let verticalSpacing: CGFloat = 14
        let labelWidth: CGFloat = 70

        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(sideInset)
            make.width.equalTo(labelWidth)
        }
        
        calenderImageButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel)
            make.trailing.equalToSuperview().offset(-sideInset)
            make.width.height.equalTo(20)
        }
        
        dividedLine.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(verticalSpacing)
            make.leading.trailing.equalToSuperview().inset(sideInset)
        }
        
        randomVerificationLabel.snp.makeConstraints { make in
            make.top.equalTo(dividedLine.snp.bottom).offset(verticalSpacing)
            make.leading.equalToSuperview().offset(sideInset)
            make.width.equalTo(labelWidth)
        }
        
        timeRangeButton.snp.makeConstraints { make in
            make.top.equalTo(randomVerificationLabel)
            make.trailing.equalToSuperview().offset(-sideInset)
            make.width.equalTo(170)
        }
        
        dividedLine2.snp.makeConstraints { make in
            make.top.equalTo(timeRangeButton.snp.bottom).offset(verticalSpacing)
            make.leading.trailing.equalToSuperview().inset(sideInset)
        }
        
        lateAllowanceLabel.snp.makeConstraints { make in
            make.top.equalTo(dividedLine2.snp.bottom).offset(verticalSpacing)
            make.leading.equalToSuperview().offset(sideInset)
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalTo(labelWidth)
        }
        
        toggleSwitch.snp.makeConstraints { make in
            make.top.bottom.equalTo(lateAllowanceLabel)
            make.trailing.equalToSuperview().offset(-sideInset)
        }
    }
}

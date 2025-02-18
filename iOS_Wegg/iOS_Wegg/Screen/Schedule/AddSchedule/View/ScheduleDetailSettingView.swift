//
//  ScheduleDetailSettingView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/18/25.
//

import UIKit

protocol ScheduleDetailSettingViewDelegate: AnyObject {
    func didTapCalendarButton()
    func didSelectStartTime()
    func didSelectFinishTime()
}

class ScheduleDetailSettingView: UIView {
    
    weak var gestureDelegate: ScheduleDetailSettingViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
        layer.cornerRadius = 25
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var dateLabel = makeLabel("날짜", .notoSans(.medium, size: 16), .customGray)
    private lazy var calenderImageButton = makeImageButton("calendar")
    
    // 날짜 선택 후 보여줄 라벨
    private lazy var updatedDateLabel = makeLabel(
        nil,
        .notoSans(.medium, size: 16),
        .customGray
    ).then {
        $0.isHidden = true
        $0.textAlignment = .right
        $0.numberOfLines = 1
    }

    private lazy var randomVerificationLabel = makeLabel(
        "랜덤 인증",
        .notoSans(.medium, size: 16),
        .customGray
    )

    private lazy var startTimeButton = makeButton(
        "00:00",
        color: .gray1
    ).then {
        $0.contentHorizontalAlignment = .right
    }
    
    private lazy var timeRangeLabel = makeLabel(
        "~",
        .notoSans(.medium, size: 16),
        .gray1
    )
    
    private lazy var finishTimeButton = makeButton(
        "00:00",
        color: .gray1
    ).then {
        $0.contentHorizontalAlignment = .right // 우측 정렬
    }
    
    private lazy var timeRangeStackView = makeStackView(10, .horizontal)

    private lazy var lateAllowanceLabel = makeLabel(
        "지각 허용",
        .notoSans(.medium, size: 16),
        .customGray
    )
    private lazy var toggleSwitch = UISwitch().then { $0.onTintColor = .primary }

    private lazy var dividedLine = makeDivider()
    private lazy var dividedLine2 = makeDivider()
    
    private let lateButtonTitles: [String] = ["1분", "3분", "7분", "10분"]
    
    private lazy var lateButtons: [UIButton] = lateButtonTitles.map { title in
        return makeButton(
            title,
            color: .secondary,
            font: .notoSans(.regular, size: 14)
        ).then { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(55)
                make.height.equalTo(21)
            }
            button.layer.cornerRadius = 10.5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.secondaryLabel.cgColor
            button.clipsToBounds = true
            button.backgroundColor = .white
        }
    }
    
    private lazy var lateAllowanceButtonStack = makeStackView(
        28,
        .horizontal,
        distribution: .fillEqually
    )
    
    // MARK: - Utility Functions
    
    private func makeLabel(
        _ title: String?,
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
        _ axis: NSLayoutConstraint.Axis,
        distribution: UIStackView.Distribution = .fill
    ) -> UIStackView {
        return UIStackView().then {
            $0.axis = axis
            $0.spacing = spacing
            $0.distribution = distribution
        }
    }

    private func makeButton(
        _ title: String,
        color: UIColor,
        font: UIFont? = nil
    ) -> UIButton {
        return UIButton().then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(color, for: .normal)
            $0.titleLabel?.font = font
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
    
    // MARK: - Public Functions
    
    /// 캘린더에서 날짜 선택 후 업데이트하는 함수
    /// - Parameters:
    ///     - isHidden: `updatedDateLabel`을 보여줄지 여부
    ///     - date: 선택된 날짜
    public func updateDateLabel(isHidden: Bool, date: String?) {
        updatedDateLabel.isHidden = isHidden
        if !isHidden {
            updatedDateLabel.text = date
        }
    }
    
    /// 랜덤인증 시간 업데이트 함수
    /// - Parameters:
    ///     - type: TimePickerType
    ///     - _ date: 선택된 시간
    public func updateRandomTimeDate(
        type: TimePickertype,
        _ date: String
    ) {
        switch type {
        case .startTime:
            startTimeButton.setTitle(date, for: .normal)
        case .finishTime:
            finishTimeButton.setTitle(date, for: .normal)
        }
    }
    
    // MARK: - Handler
    
    @objc private func handleCalendarButton() {
        gestureDelegate?.didTapCalendarButton()
    }
    
    @objc private func startTimeButtonHandler() {
        gestureDelegate?.didSelectStartTime()
    }
    
    @objc private func finishTimeButtonHandler() {
        gestureDelegate?.didSelectFinishTime()
    }
}

private extension ScheduleDetailSettingView {
    func setupView() {
        addComponents()
        setupGestures()
        setupStackView()
        constraints()
    }
    
    func setupGestures() {
        calenderImageButton.addTarget(
            self,
            action: #selector(handleCalendarButton),
            for: .touchUpInside
        )
        startTimeButton.addTarget(
            self,
            action: #selector(startTimeButtonHandler),
            for: .touchUpInside
        )
        finishTimeButton.addTarget(
            self,
            action: #selector(finishTimeButtonHandler),
            for: .touchUpInside
        )
    }
    
    func setupStackView() {
        [
            startTimeButton,
            timeRangeLabel,
            finishTimeButton
        ].forEach {
            timeRangeStackView.addArrangedSubview($0)
        }
        
        lateButtons.forEach(lateAllowanceButtonStack.addArrangedSubview)
    }
    
    func addComponents() {
        [
            dateLabel,
            updatedDateLabel,
            calenderImageButton,
            dividedLine,
            randomVerificationLabel,
            timeRangeStackView,
            dividedLine2,
            lateAllowanceLabel,
            toggleSwitch,
            lateAllowanceButtonStack
        ].forEach(addSubview)
    }
    
    func constraints() {
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
        
        updatedDateLabel.snp.makeConstraints { make in
            make.top.equalTo(calenderImageButton)
            make.trailing.lessThanOrEqualTo(calenderImageButton.snp.leading).offset(-5)
            make.width.equalTo(labelWidth + 70)
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
        
        timeRangeStackView.snp.makeConstraints { make in
            make.top.equalTo(randomVerificationLabel)
            make.trailing.equalToSuperview().offset(-sideInset)
            make.width.equalTo(150)
        }
        
        dividedLine2.snp.makeConstraints { make in
            make.top.equalTo(timeRangeStackView.snp.bottom).offset(verticalSpacing)
            make.leading.trailing.equalToSuperview().inset(sideInset)
        }
        
        lateAllowanceLabel.snp.makeConstraints { make in
            make.top.equalTo(dividedLine2.snp.bottom).offset(verticalSpacing)
            make.leading.equalToSuperview().offset(sideInset)
            make.width.equalTo(labelWidth)
        }
        
        toggleSwitch.snp.makeConstraints { make in
            make.top.bottom.equalTo(lateAllowanceLabel)
            make.trailing.equalToSuperview().offset(-sideInset)
        }
        
        lateAllowanceButtonStack.snp.makeConstraints { make in
            make.top.equalTo(toggleSwitch.snp.bottom).offset(verticalSpacing + 7)
            make.leading.trailing.equalToSuperview().inset(sideInset)
            make.bottom.equalToSuperview().offset(-verticalSpacing)
        }
    }
}

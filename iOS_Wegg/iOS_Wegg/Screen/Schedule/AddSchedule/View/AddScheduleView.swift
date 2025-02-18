//
//  AddScheduleView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/10/25.
//

import UIKit
import Then

protocol AddScheduleGestureDelegate: AnyObject {
    func didTapCalendarButton()
    func didTapDoneButton()
    func didTapCancelButton()
    func didSelectStartTime()
    func didSelectFinishTime()
}

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
    
    private lazy var cancelButton = makeButton("취소", color: .primary)
    private lazy var createEggLabel = makeLabel(
        "create egg",
        .notoSans(.medium, size: 16),
        .customGray
    ).then {
        $0.textAlignment = .left
    }
    private lazy var saveButton = makeButton("저장", color: .primary)
    
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
    
    lazy var searchResultListView = AddScheduleSearchListView().then {
        $0.backgroundColor = .white
        $0.isHidden = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.secondary.cgColor
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
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
    
    private lazy var selectedPlaceLabel = makeLabel(
        nil,
        .notoSans(.medium, size: 14),
        .secondary
    ).then {
        $0.isHidden = true
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }

    private lazy var detailSettingLabel = makeLabel(
        "세부 설정",
        .notoSans(.medium, size: 15)
        , .customGray
    )

    private lazy var detailSettingCardView = makeCardView()

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
    
    /// 검색 결과 드롭다운
    public func toggleSearchResultList(_ isHidden: Bool) {
        searchResultListView.isHidden = isHidden
    }
    
    public func updateSearchResultLabel(
        _ text: String,
        isHidden: Bool
    ) {
        selectedPlaceLabel.text = text
        selectedPlaceLabel.isHidden = isHidden
    }
    
    public func getSearchResultListView() -> UIView {
        return searchResultListView
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
    
    // MARK: - Action Handler
    
    @objc private func handleCalendarButton() {
        gestureDelegate?.didTapCalendarButton()
    }
    
    @objc private func handleSaveButton() {
        gestureDelegate?.didTapDoneButton()
    }
    
    @objc private func handleCancelButton() {
        gestureDelegate?.didTapCancelButton()
    }
    
    @objc private func startTimeButtonHandler() {
        gestureDelegate?.didSelectStartTime()
    }
    
    @objc private func finishTimeButtonHandler() {
        gestureDelegate?.didSelectFinishTime()
    }
    
    /// 키보드 내리는 핸들러
    @objc private func handleDismissKeyboard() {
        endEditing(true)
        toggleSearchResultList(true)
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
        cancelButton.addTarget(
            self,
            action: #selector(handleCancelButton),
            for: .touchUpInside
        )
        saveButton.addTarget(
            self,
            action: #selector(handleSaveButton),
            for: .touchUpInside
        )
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
        
        // 키보드 내리는 제스처 추가
        let dismissKeyboardGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleDismissKeyboard)
        )
        dismissKeyboardGesture.cancelsTouchesInView = false
        addGestureRecognizer(dismissKeyboardGesture)
        
    }
    
    func setupStackView() {
        [cancelButton, createEggLabel, saveButton].forEach { headerStackView.addArrangedSubview($0)
        }
        [
            startTimeButton,
            timeRangeLabel,
            finishTimeButton
        ].forEach {
            timeRangeStackView.addArrangedSubview($0)
        }
    }
    
    func addComponents() {
        [
            headerStackView,
            placeSettingLabel,
            placeSearchBar,
            searchResultListView,
            createPlaceImageView,
            yellowLogoIcon,
            selectedPlaceLabel,
            detailSettingLabel,
            detailSettingCardView
        ].forEach(addSubview)
        bringSubviewToFront(searchResultListView) // 최상위로 배치

        [
            dateLabel,
            updatedDateLabel,
            calenderImageButton,
            dividedLine,
            randomVerificationLabel,
            timeRangeStackView,
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
        
        searchResultListView.snp.makeConstraints { make in
            make.top.equalTo(placeSearchBar.snp.bottom).offset(12)
            make.leading.trailing.equalTo(placeSearchBar)
            make.height.equalTo(200)
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
        
        selectedPlaceLabel.snp.makeConstraints { make in
            make.top.equalTo(yellowLogoIcon.snp.bottom).offset(5)
            make.centerX.equalTo(createPlaceImageView)
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
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalTo(labelWidth)
        }
        
        toggleSwitch.snp.makeConstraints { make in
            make.top.bottom.equalTo(lateAllowanceLabel)
            make.trailing.equalToSuperview().offset(-sideInset)
        }
    }
}

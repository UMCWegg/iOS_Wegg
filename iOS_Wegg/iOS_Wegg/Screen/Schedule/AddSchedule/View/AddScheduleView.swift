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
    
    lazy var placeSettingLabel = makeLabel(
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
        // 텍스트 필드의 배경을 제거(기본 회색 색상 제거)
        let textField = $0.searchTextField
        textField.backgroundColor = .clear // 배경 투명화
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
    }
    
    lazy var createPlaceImageView = makeImageView(
        "CreatePlace",
        contentMode: .scaleAspectFit
    )
    
    lazy var yellowLogoIcon = makeImageView("yellow_wegg_icon").then {
        $0.layer.shadowColor = UIColor.secondary.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.shadowRadius = 2.5
        $0.layer.shadowOpacity = 0.2
    }
    
    lazy var detailSettingLabel = makeLabel(
        "세부 설정",
        .notoSans(.medium, size: 15),
        .customGray
    )
    
    lazy var detailSettingCardView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.secondaryLabel.cgColor
        $0.layer.cornerRadius = 25
    }
    
    lazy var dateLabel = makeLabel(
        "날짜",
        .notoSans(.medium, size: 16),
        .customGray
    )
    
    lazy var calenderImageButton = UIButton().then {
        $0.setImage(UIImage(named: "calendar"), for: .normal)
    }
    
    lazy var randomVerificationLabel = makeLabel(
        "랜던 인증",
        .notoSans(.medium, size: 16),
        .customGray
    )
    
    lazy var startTimeButton = makeButton("00:00", color: .gray1)
    
    lazy var timeRangeSymbol = makeLabel(
        "~",
        .notoSans(.medium, size: 16),
        .gray1
    )
    
    lazy var finishTimeButton = makeButton("00:00", color: .gray1)
    
    private lazy var timeRangeStackView = makeStackView(38, .horizontal)
    
    lazy var lateAllowanceLabel = makeLabel(
        "지각 허용",
        .notoSans(.medium, size: 16),
        .customGray
    )
    
    lazy var toggleSwitch = UISwitch().then {
        $0.onTintColor = .primary
    }
    
    lazy var dividedLine = UIView().then {
        $0.backgroundColor = .customGray2
        $0.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
    
    lazy var dividedLine2 = UIView().then {
        $0.backgroundColor = .customGray2
        $0.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
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
    
    func makeButton(
        _ title: String = "",
        color: UIColor = .black
    ) -> UIButton {
        return UIButton().then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(color, for: .normal)
            $0.titleLabel?.font = .notoSans(.medium, size: 16)
        }
    }
    
}

private extension AddScheduleView {
    func setupView() {
        setupStackView()
        addComponents()
        constraints()
        setupDetailSettingCardView()
    }
    
    func setupStackView() {
        [
            cancelLabel,
            createEggLabel,
            saveLabel
        ].forEach {
            headerStackView.addArrangedSubview($0)
        }
        
        [
            startTimeButton,
            timeRangeSymbol,
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
            createPlaceImageView,
            yellowLogoIcon,
            detailSettingLabel,
            detailSettingCardView
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
        
        placeSettingLabel.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(18)
            make.leading.lessThanOrEqualToSuperview().offset(21)
            make.width.equalTo(80)
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
    
    func setupDetailSettingCardView() {
        [
            dateLabel,
            calenderImageButton,
            dividedLine,
            randomVerificationLabel,
            timeRangeStackView,
            dividedLine2,
            lateAllowanceLabel,
            toggleSwitch
        ].forEach(detailSettingCardView.addSubview)
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.lessThanOrEqualToSuperview().offset(17)
            make.width.equalTo(70)
        }
        
        calenderImageButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.top)
            make.trailing.lessThanOrEqualToSuperview().offset(-17)
            make.width.height.equalTo(20)
        }
        
        dividedLine.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(17)
        }
        
        randomVerificationLabel.snp.makeConstraints { make in
            make.top.equalTo(dividedLine.snp.bottom).offset(14)
            make.leading.lessThanOrEqualToSuperview().offset(17)
            make.width.equalTo(70)
        }
        
        timeRangeStackView.snp.makeConstraints { make in
            make.top.equalTo(randomVerificationLabel.snp.top)
            make.trailing.lessThanOrEqualToSuperview().offset(-17)
            make.width.equalTo(180)
        }
        
        dividedLine2.snp.makeConstraints { make in
            make.top.equalTo(timeRangeStackView.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(17)
        }
        
        lateAllowanceLabel.snp.makeConstraints { make in
            make.top.equalTo(dividedLine2.snp.top).offset(14)
            make.leading.lessThanOrEqualToSuperview().offset(17)
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalTo(70)
        }
        
        toggleSwitch.snp.makeConstraints { make in
            make.top.equalTo(lateAllowanceLabel.snp.top)
            make.trailing.lessThanOrEqualToSuperview().offset(-17)
            make.bottom.equalTo(lateAllowanceLabel.snp.bottom)
        }
        
    }
}

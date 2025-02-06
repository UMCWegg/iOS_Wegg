//
//  PlaceDetailView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/5/25.
//

import UIKit
import Then
import SnapKit

class PlaceDetailView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var yellowIconImageView = makeImageView(imageName: "yellow_wegg_icon")
    
    lazy var styledVisitorCountLabel = UILabel().then {
        let fullText = NSMutableAttributedString()
        
        let visitorCountText = NSAttributedString(
            string: "132명의 ",
            attributes: [
            .font: UIFont.notoSans(.medium, size: 12) ?? UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.primary
        ])
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "weggy")
        imageAttachment.bounds = CGRect(x: 0, y: -2, width: 50, height: 12)
        
        let weggyAttributedString = NSAttributedString(attachment: imageAttachment)

        let visitedPlaceText = NSAttributedString(
            string: " 가 이 장소를 방문하였어요",
            attributes: [
            .font: UIFont.notoSans(.medium, size: 12) ?? UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.primary
        ])

        fullText.append(visitorCountText)
        fullText.append(weggyAttributedString)
        fullText.append(visitedPlaceText)
        
        $0.attributedText = fullText
    }
    
    lazy var verificationCount = makeLabel(
        font: .notoSans(.medium, size: 14),
        .gray1
    )
    
    lazy var saveCount = makeLabel(
        font: .notoSans(.medium, size: 14),
        .gray1
    )
    
    lazy var starImageView = makeImageView(imageName: "star")
    
    // TODO: [25.02.05] 추후 CollectionView 구현 예정 - 작성자: 이재원
    lazy var studyImageCollectionView = UIView().then {
        $0.backgroundColor = .blue
    }
    
    lazy var addressIconImageView = makeImageView(imageName: "wegg_icon")
    lazy var addressLabel = makeLabel(
        font: .notoSans(.medium, size: 14), .black
    )
    
    lazy var phoneIconImageView = makeImageView(imageName: "brown_phone")
    lazy var phoneNumberLabel = makeLabel(
        font: .notoSans(.medium, size: 14), .black
    )
    
    lazy var openingIconImageView = makeImageView(imageName: "brown_clock")
    lazy var openingInfoLabel = makeLabel(
        font: .notoSans(.medium, size: 14), .black
    )
    
    lazy var webUrlIconImageView = makeImageView(imageName: "brown_web")
    lazy var webUrlLabel = makeLabel(
        font: .notoSans(.medium, size: 14), .primary
    )
    
    private lazy var styledVisitorTextStack = makeStackView(spacing: 8, axis: .horizontal)
    // verificationCount와 saveCount 스택 쌓음
    private lazy var statusStack = makeStackView(spacing: 8, axis: .horizontal)
    private lazy var addressStack = makeStackView(spacing: 8, axis: .horizontal)
    private lazy var phoneStack = makeStackView(spacing: 8, axis: .horizontal)
    private lazy var openingInfoStack = makeStackView(spacing: 8, axis: .horizontal)
    private lazy var webUrlStack = makeStackView(spacing: 8, axis: .horizontal)
    
    // MARK: - Function
    
    /// 중복 라벨 처리 함수
    /// - Parameter font: 텍스트 폰트 지정
    /// - Returns: 지정된 폰트 UILabel 반환
    func makeLabel(
        font: UIFont?,
        _ color: UIColor
    ) -> UILabel {
        let label = UILabel()
        label.font = font ?? UIFont.systemFont(ofSize: 19, weight: .medium)
        label.textColor = color
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }
    
    func makeImageView(imageName: String) -> UIImageView {
        let image = UIImageView()
        image.image = UIImage(named: imageName)
        image.contentMode = .scaleAspectFill
        return image
    }
    
    func makeStackView(
        spacing: CGFloat,
        axis: NSLayoutConstraint.Axis,
        distribution: UIStackView.Distribution = .fill
    ) -> UIStackView {
        let stack = UIStackView()
        stack.axis = axis
        stack.spacing = spacing
        stack.distribution = distribution
        
        return stack
    }
}

private extension PlaceDetailView {

    func setupView() {
        setupStackView()
        addComponents()
        constraints()
    }
    
    func setupStackView() {
        [yellowIconImageView, styledVisitorCountLabel].forEach {
            styledVisitorTextStack.addArrangedSubview($0)
        }
        
        [verificationCount, saveCount].forEach {
            statusStack.addArrangedSubview($0)
        }
        
        [addressIconImageView, addressLabel].forEach {
            addressStack.addArrangedSubview($0)
        }
        
        [phoneIconImageView, phoneNumberLabel].forEach {
            phoneStack.addArrangedSubview($0)
        }
        
        [openingIconImageView, openingInfoLabel].forEach {
            openingInfoStack.addArrangedSubview($0)
        }
        
        [webUrlIconImageView, webUrlLabel].forEach {
            webUrlStack.addArrangedSubview($0)
        }
    }
    
    func addComponents() {
        
        // MARK: - addSubview
        
        [
            styledVisitorTextStack,
            statusStack,
            studyImageCollectionView,
            starImageView,
            addressStack,
            phoneStack,
            openingInfoStack,
            webUrlStack
        ].forEach {
            addSubview($0)
        }
        
        // MARK: - 레이아웃 크기 설정
        
        // 아이콘 크기 설정
        [
            addressIconImageView,
            phoneIconImageView,
            openingIconImageView,
            webUrlIconImageView
        ].forEach {
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(
                    MapViewLayout.PlaceDetail.iconSize
                )
            }
        }
        
        yellowIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(
                MapViewLayout.yellowLogoIcon
            )
        }
        
        // 라벨 길이 설정
        [
            styledVisitorTextStack,
            statusStack,
            starImageView,
            addressStack,
            phoneStack,
            openingInfoStack,
            webUrlStack
        ].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(20)
            }
        }
    }
    
    func constraints() {
        styledVisitorTextStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(21)
            make.trailing.greaterThanOrEqualToSuperview().inset(100)
        }
        
        statusStack.snp.makeConstraints { make in
            make.top.equalTo(styledVisitorTextStack.snp.bottom).offset(10)
            make.leading.lessThanOrEqualToSuperview().inset(21) // leading만 설정하여 자동 크기
        }
        
        starImageView.snp.makeConstraints { make in
            make.top.equalTo(styledVisitorTextStack.snp.bottom).offset(10)
            make.trailing.lessThanOrEqualToSuperview().inset(21) // trailing만 설정하여 자동 크기 조절
        }
        
        studyImageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(statusStack.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(230) // 임시 크기 지정
        }
        
        addressStack.snp.makeConstraints { make in
            make.top.equalTo(studyImageCollectionView.snp.bottom).offset(50)
            make.leading.lessThanOrEqualToSuperview().inset(21) // leading만 설정하여 자동 크기
            make.height.equalTo(277)
        }
        
        phoneStack.snp.makeConstraints { make in
            make.top.equalTo(addressStack.snp.bottom).offset(50)
            make.leading.lessThanOrEqualToSuperview().inset(21) // leading만 설정하여 자동 크기
            make.height.equalTo(277)
        }
        
        openingInfoStack.snp.makeConstraints { make in
            make.top.equalTo(phoneStack.snp.bottom).offset(50)
            make.leading.lessThanOrEqualToSuperview().inset(21) // leading만 설정하여 자동 크기
            make.height.equalTo(277)
        }
        
        webUrlStack.snp.makeConstraints { make in
            make.top.equalTo(openingInfoStack.snp.bottom).offset(50)
            make.leading.lessThanOrEqualToSuperview().inset(21) // leading만 설정하여 자동 크기
            make.height.equalTo(277)
        }
    }
}

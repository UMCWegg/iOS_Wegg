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
    
    weak var gestureDelegate: PlaceDetailViewGestureDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel = makeLabel(
        UIFont.notoSans(.bold, size: 16), .secondary
    )
    
    lazy var categoryLabel = makeLabel(
        .notoSans(.medium, size: 14), .gray1
    )
    
    private lazy var headerTitleStack = makeStackView(8, .horizontal)
    
    // MARK: - ImageViews
    
    lazy var yellowIconImageView = makeImageView("yellow_wegg_icon")
    lazy var favoriteStarImageView = makeImageView("star")

    // 아이콘 이미지 뷰 배열을 한 번에 생성
    private lazy var iconImageViews: [UIImageView] = [
        "wegg_icon",
        "brown_phone",
        "brown_clock",
        "brown_web"
    ].map { makeImageView($0) }

    // 배열을 통해 개별 아이콘 뷰에 접근할 수 있도록 변수 선언
    private lazy var addressIconImageView = iconImageViews[0]
    private lazy var phoneIconImageView = iconImageViews[1]
    private lazy var openingIconImageView = iconImageViews[2]
    private lazy var webUrlIconImageView = iconImageViews[3]

    // MARK: - Labels
    
    lazy var verificationCount = makeLabel(.notoSans(.medium, size: 14), .gray1)
    lazy var saveCount = makeLabel(.notoSans(.medium, size: 14), .gray1)

    // 공통 라벨을 배열을 사용해 일괄 생성
    private lazy var infoLabels: [UILabel] = (0..<4).map { index in
        makeLabel(.notoSans(.medium, size: 14), index == 3 ? .primary : .black)
    }

    // 배열을 통해 개별 라벨에 접근할 수 있도록 변수 선언
    lazy var addressLabel = infoLabels[0]
    lazy var phoneNumberLabel = infoLabels[1]
    lazy var openingInfoLabel = infoLabels[2]
    lazy var webUrlLabel = infoLabels[3]

    // MARK: - Styled Visitor Count Label
    
    lazy var styledVisitorCountLabel = UILabel().then {
        let fullText = NSMutableAttributedString()
        
        let visitorCountText = NSAttributedString(
            string: "132명의 ",
            attributes: [
                .font: UIFont.notoSans(.medium, size: 12) ?? UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.primary
            ]
        )
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "weggy")
        imageAttachment.bounds = CGRect(x: 0, y: -2, width: 50, height: 12)
        
        let weggyAttributedString = NSAttributedString(attachment: imageAttachment)

        let visitedPlaceText = NSAttributedString(
            string: " 가 이 장소를 방문하였어요",
            attributes: [
                .font: UIFont.notoSans(.medium, size: 12) ?? UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.primary
            ]
        )

        fullText.append(visitorCountText)
        fullText.append(weggyAttributedString)
        fullText.append(visitedPlaceText)

        $0.attributedText = fullText
    }

    // MARK: - CollectionView
    
    public lazy var studyImageCollectionView = UICollectionView(
        frame: bounds,
        collectionViewLayout: PlaceDetailCollectionLayout.createCompositionalLayout()
    ).then {
        $0.register(
            PlaceDetailImageCell.self,
            forCellWithReuseIdentifier: PlaceDetailImageCell.identifier
        )
    }

    // MARK: - StackViews
    private lazy var styledVisitorTextStack = makeStackView(8, .horizontal)
    private lazy var statusStack = makeStackView(8, .horizontal)

    // 공통 스택뷰 배열을 사용하여 리팩토링
    private lazy var infoStacks: [UIStackView] = [
        makeStackView(8, .horizontal),
        makeStackView(8, .horizontal),
        makeStackView(8, .horizontal),
        makeStackView(8, .horizontal)
    ]

    // 배열을 통해 개별 스택뷰에 접근할 수 있도록 변수 선언
    private lazy var addressStack = infoStacks[0]
    private lazy var phoneStack = infoStacks[1]
    private lazy var openingInfoStack = infoStacks[2]
    private lazy var webUrlStack = infoStacks[3]
    
    lazy var bottomBackgorundView = UIView().then {
        $0.backgroundColor = .yellowBg
    }
    
    lazy var placeCreateButton = UIButton(type: .system).then {
        var config = UIButton.Configuration.filled()
        config.title = "이 장소로 알 생성하기"
        config.image = UIImage(named: "yellow_wegg_icon")
        config.imagePlacement = .leading
        config.imagePadding = 5
        config.baseBackgroundColor = .white
        config.baseForegroundColor = UIColor.secondary
        config.cornerStyle = .capsule
        
        // Dynamic Type 비활성화
        let fontTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var attributes = attributes
            attributes.font = UIFont.notoSans(.medium, size: 14) // 원하는 커스텀 폰트 적용
            return attributes
        }
        config.titleTextAttributesTransformer = fontTransformer
        
        // 내부 여백 설정 (양쪽 여백 조정)
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 10, leading: 0, bottom: 10, trailing: 0
        )
        
        $0.clipsToBounds = true
        $0.layer.shadowColor = UIColor.secondary.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.layer.shadowRadius = 7
        $0.layer.borderColor = UIColor.secondary.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 19
        
        $0.configuration = config
    }
    
    private lazy var dividedLine = UIView().then {
        $0.backgroundColor = .gray1
    }

    // MARK: - Utility Functions
    
    /// UILabel 생성 함수
    func makeLabel(
        _ font: UIFont?,
        _ color: UIColor
    ) -> UILabel {
        return UILabel().then {
            $0.font = font ?? UIFont.systemFont(ofSize: 19, weight: .medium)
            $0.textColor = color
            $0.numberOfLines = 2
            $0.textAlignment = .left
        }
    }

    /// UIImageView 생성 함수
    func makeImageView(_ imageName: String) -> UIImageView {
        return UIImageView().then {
            $0.image = UIImage(named: imageName)
            $0.contentMode = .scaleAspectFill
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
    
    // MARK: - Action Handler
    
    @objc private func favoriteStarButtonTapped() {
        gestureDelegate?.didTapFavoriteStar()
    }
    
    @objc private func placeCreateButtonTapped() {
        gestureDelegate?.didTapPlaceCreateButton()
    }
}

// MARK: - Set Up Extenstion

private extension PlaceDetailView {
    
    func setupView() {
        setupGestures()
        setupStackView()
        addComponents()
        constraints()
    }
    
    func setupGestures() {
        let starTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(favoriteStarButtonTapped)
        )
        favoriteStarImageView.isUserInteractionEnabled = true
        favoriteStarImageView.addGestureRecognizer(starTapGesture)
        
        placeCreateButton.addTarget(
            self,
            action: #selector(placeCreateButtonTapped),
            for: .touchUpInside
        )
    }
    
    func setupStackView() {
        // 스택뷰와 추가할 서브뷰를 매핑한 배열 생성
        let stackViewMappings: [(UIStackView, [UIView])] = [
            (headerTitleStack, [titleLabel, categoryLabel]),
            (styledVisitorTextStack, [yellowIconImageView, styledVisitorCountLabel]),
            (statusStack, [verificationCount, saveCount]),
            (addressStack, [addressIconImageView, addressLabel]),
            (phoneStack, [phoneIconImageView, phoneNumberLabel]),
            (openingInfoStack, [openingIconImageView, openingInfoLabel]),
            (webUrlStack, [webUrlIconImageView, webUrlLabel])
        ]
        
        // `forEach`를 사용하여 각 스택뷰에 서브뷰를 추가
        stackViewMappings.forEach { stackView, subviews in
            subviews.forEach { stackView.addArrangedSubview($0) }
        }
    }
    
    func addComponents() {
        // MARK: - addSubview
        [
            headerTitleStack,
            styledVisitorTextStack,
            statusStack,
            studyImageCollectionView,
            favoriteStarImageView,
            addressStack,
            phoneStack,
            openingInfoStack,
            webUrlStack,
            bottomBackgorundView,
            placeCreateButton,
            dividedLine
        ].forEach(addSubview)
        
        // MARK: - 레이아웃 크기 설정
        
        // 아이콘 크기 설정 (공통 아이콘 + Yellow 아이콘 포함)
        let iconViews = [
            addressIconImageView,
            phoneIconImageView,
            openingIconImageView,
            webUrlIconImageView,
            yellowIconImageView
        ]
        
        iconViews.forEach { icon in
            icon.snp.makeConstraints { make in
                let size = (icon == yellowIconImageView) ?
                MapViewLayout.yellowLogoIcon : MapViewLayout.PlaceDetail.iconSize
                make.width.height.equalTo(size)
            }
        }
        
        // 라벨 및 스택뷰 높이 설정
        let labelViews = [
            headerTitleStack,
            styledVisitorTextStack,
            statusStack,
            favoriteStarImageView,
            addressStack,
            phoneStack,
            openingInfoStack,
            webUrlStack
        ]
        
        labelViews.forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(20)
            }
        }
    }
    
    func constraints() {
        headerTitleStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(
                MapViewLayout.BottomSheetHeader.topOffset
            )
            make.leading.lessThanOrEqualToSuperview().inset(21)
        }
        
        styledVisitorTextStack.snp.makeConstraints { make in
            make.top.equalTo(headerTitleStack.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(21)
            make.trailing.greaterThanOrEqualToSuperview().inset(100)
        }
        
        statusStack.snp.makeConstraints { make in
            make.top.equalTo(styledVisitorTextStack.snp.bottom).offset(10)
            make.leading.lessThanOrEqualToSuperview().inset(21)
        }
        
        favoriteStarImageView.snp.makeConstraints { make in
            make.top.equalTo(styledVisitorTextStack.snp.bottom).offset(10)
            make.trailing.lessThanOrEqualToSuperview().inset(21)
        }
        
        studyImageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(statusStack.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(230)
        }
        
        // 공통 height 적용할 스택뷰 배열
        let stackViews = [addressStack, phoneStack, openingInfoStack, webUrlStack]
        
        stackViews.enumerated().forEach { index, stackView in
            stackView.snp.makeConstraints { make in
                make.top.equalTo(
                    index == 0 ?
                    studyImageCollectionView.snp.bottom
                    : stackViews[index - 1].snp.bottom
                ).offset(45)
                make.leading.lessThanOrEqualToSuperview().inset(21)
                make.height.equalTo(277)
            }
        }
        
        bottomBackgorundView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(157)
        }
        
        placeCreateButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(73)
            make.width.equalTo(170)
            make.height.equalTo(37)
        }
        
        dividedLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(bottomBackgorundView.snp.top)
        }
    }
}

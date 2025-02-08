//
//  HotPlaceSheetView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/28/25.
//

import UIKit
import SnapKit

class HotPlaceSheetView: UIView {
    
    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property
    
    public lazy var hotPlaceCollectionView = UICollectionView(
        frame: bounds,
        collectionViewLayout: HotPlaceCollectionLayout.createCompositionalLayout()
    ).then {
        $0.backgroundColor = .white
        $0.register(
            HotPlaceCellHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HotPlaceCellHeader.identifier
        )
        $0.register(
            HotPlaceCell.self,
            forCellWithReuseIdentifier: HotPlaceCell.identifier
        )
        $0.register(
            SectionSeparatorFooter.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: SectionSeparatorFooter.identifier
        )
    }
    
    lazy var logoImageView = UIImageView().then {
        $0.image = UIImage(named: "yellow_wegg_icon")
        $0.contentMode = .scaleAspectFill
    }
    
    /// `logoLabel`은 피그마 디자인에 맞춰 텍스트와 이미지를 결합한 라벨.
    ///
    /// NSMutableAttributedString을 사용하여 텍스트와 이미지를 결합한 이유:
    /// - 피그마 디자인에서 "주변" + 이미지 + "핫플"이 하나의 요소로 보여짐
    /// - 단일 라벨로 구성해 레이아웃 관리가 용이함
    /// 참고: 피그마 화면 "HotPlace Sheet"의 상단 헤더 디자인
    lazy var logoLabel = UILabel().then {
        let fullText = NSMutableAttributedString()
        
        let surroundingText = NSAttributedString(string: "주변 ", attributes: [
            .font: UIFont.notoSans(.medium, size: 16) ?? UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ])
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "weggy_border")
        imageAttachment.bounds = CGRect(x: 0, y: -2, width: 60, height: 18)
        
        let imageAttributedString = NSAttributedString(attachment: imageAttachment)

        let hotspotText = NSAttributedString(string: " 핫플", attributes: [
            .font: UIFont.notoSans(.medium, size: 16) ?? UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ])

        fullText.append(surroundingText)
        fullText.append(imageAttributedString)
        fullText.append(hotspotText)
        
        $0.attributedText = fullText
    }
    
    /// 헤더와 컬렉션뷰 사이의 구분선
    lazy var dividedLineView = UIView().then {
        $0.backgroundColor = .gray
    }
    
    private lazy var distanceButtonView = makeButtonView(title: "거리순", backgroundColor: .primary)
    private lazy var verficationButtonView = makeButtonView(title: "인증순")
    lazy var bottomSheetTitleStack = makeStackView(spacing: 8, axis: .horizontal)
    lazy var bottomSheetButtonStack = makeStackView(spacing: 8, axis: .horizontal)
    
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
    
    func makeButtonView(
        title: String,
        backgroundColor: UIColor = .white
    ) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.secondary, for: .normal)
        button.titleLabel?.font = .notoSans(.medium, size: 10)
        button.layer.borderColor = UIColor.secondary.cgColor
        button.layer.borderWidth = 1
        // 기본적으로 높이의 절반으로 설정(->피그마와 차이가 있을수 있음)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true // 테두리와 배경이 버튼의 경계에 맞도록 설정
        button.backgroundColor = backgroundColor
        return button
    }
    
    func updateCollectionViewLayout() {
        hotPlaceCollectionView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            
            if dividedLineView.isHidden {
                // dividedLineView가 숨겨지면 최상단으로 이동
                make.top.equalToSuperview().offset(
                    MapViewLayout.BottomSheetHeader.topOffset
                )
            } else {
                make.top.equalTo(dividedLineView.snp.bottom) // 기존 레이아웃 유지
            }
        }
        layoutIfNeeded() // 레이아웃 변경 즉시 적용
    }
}

// MARK: - Set UP Extenstion

private extension HotPlaceSheetView {
    func setupView() {
        addComponents()
        constraints()
        setupStackView()
    }
    
    func setupStackView() {
        let initialtHeight: CGFloat = 20
        let buttonWidth: CGFloat = 49
        
        [logoImageView, logoLabel].forEach {
            bottomSheetTitleStack.addArrangedSubview($0)
        }
        
        [distanceButtonView, verficationButtonView].forEach {
            bottomSheetButtonStack.addArrangedSubview($0)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(
                MapViewLayout.yellowLogoIcon
            )
        }
        
        logoLabel.snp.makeConstraints { make in
            make.width.equalTo(150)
        }
        
        distanceButtonView.snp.makeConstraints { make in
            make.width.equalTo(buttonWidth)
            make.height.equalTo(initialtHeight)
        }
        
        verficationButtonView.snp.makeConstraints { make in
            make.width.equalTo(buttonWidth)
            make.height.equalTo(initialtHeight)
        }
    }
    
    func addComponents() {
        [
            bottomSheetTitleStack,
            bottomSheetButtonStack,
            dividedLineView,
            hotPlaceCollectionView
        ].forEach {
            addSubview($0)
        }
    }
    
    func constraints() {
        bottomSheetTitleStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(
                MapViewLayout.BottomSheetHeader.topOffset
            )
            make.leading.equalToSuperview().offset(
                MapViewLayout.BottomSheetHeader.leadingOffset
            )
            make.bottom.equalTo(dividedLineView.snp.top).offset(
                MapViewLayout.BottomSheetHeader.bottomOffset
            )
        }
        
        bottomSheetButtonStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(
                MapViewLayout.BottomSheetHeader.topOffset
            )
            make.trailing.equalToSuperview().offset(
                MapViewLayout.BottomSheetHeader.trailingOffset
            )
            make.bottom.equalTo(dividedLineView.snp.top).offset(
                MapViewLayout.BottomSheetHeader.bottomOffset
            )
        }
        
        dividedLineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(hotPlaceCollectionView.snp.top).offset(-12)
            make.height.equalTo(0.5)
        }
        
        hotPlaceCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

//
//  BaseCellHeader.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/29/25.
//

import UIKit
import SnapKit

protocol HotPlaceCellGestureDelegate: AnyObject {
    func didTapHotPlaceCellHeader()
}

class HotPlaceCellHeader: UICollectionReusableView {
    
    weak var gestureDelegate: HotPlaceCellGestureDelegate?
    
    static let identifier = "HotPlaceCellHeader"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property
    
    lazy var logoImageView = UIImageView().then {
        $0.image = UIImage(named: "yellow_wegg_icon")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var titleLabel = makeLabel(
        font: UIFont.notoSans(.bold, size: 16),
        .secondary
    )
    
    lazy var categoryLabel = makeLabel(
        font: .notoSans(.medium, size: 14),
        .gray1
    ).then {
        $0.textAlignment = .left
    }
    
    lazy var verificationCount = makeLabel(
        font: .notoSans(.medium, size: 14),
        .gray1
    )
    
    lazy var saveCount = makeLabel(
        font: .notoSans(.medium, size: 14),
        .gray1
    )
    
    private lazy var headerTitleStack = makeStackView(spacing: 8, axis: .horizontal)
    private lazy var headerStatusStack = makeStackView(spacing: 8, axis: .horizontal)
    
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
    
    /// 헤더 셀 초기화 설정 함수
    public func configure(model: HotPlaceHeaderModel) {
        titleLabel.text = model.title
        categoryLabel.text = model.category
        verificationCount.text = model.verificationCount
        saveCount.text = model.saveCount
    }
    
    @objc private func headerTitleStackTapped() {
        gestureDelegate?.didTapHotPlaceCellHeader()
    }
    
}

// MARK: - Set Up Extenstion

private extension HotPlaceCellHeader {
    func setupView() {
        setupStackView()
        setupGestures()
        addComponents()
        constraints()
    }
    
    func setupGestures() {
        let headerTitleTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(headerTitleStackTapped)
        )
        headerTitleStack.isUserInteractionEnabled = true
        headerTitleStack.addGestureRecognizer(headerTitleTapGesture)
    }
    
    func setupStackView() {
        let labelHeight: CGFloat = 20
        
        [logoImageView, titleLabel, categoryLabel].forEach {
            headerTitleStack.addArrangedSubview($0)
        }
        
        [verificationCount, saveCount].forEach {
            headerStatusStack.addArrangedSubview($0)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(
                MapViewLayout.yellowLogoIcon
            )
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(labelHeight)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(26)
            make.height.equalTo(labelHeight)
        }
        
        verificationCount.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(55)
            make.height.equalTo(labelHeight)
        }
        
        saveCount.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(55)
            make.height.equalTo(labelHeight)
        }
    }
    
    func addComponents() {
        [headerTitleStack, headerStatusStack].forEach {
            addSubview($0)
        }
    }
    
    func constraints() {
        headerTitleStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(
                MapViewLayout.BottomSheetContent.topOffset
            )
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(
                MapViewLayout.BottomSheetContent.bottomOffset
            )
        }
        
        headerStatusStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(
                MapViewLayout.BottomSheetContent.topOffset
            )
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(
                MapViewLayout.BottomSheetContent.bottomOffset
            )
        }
    }
}

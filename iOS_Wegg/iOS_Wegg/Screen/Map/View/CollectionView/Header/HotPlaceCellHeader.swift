//
//  BaseCellHeader.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/29/25.
//

import UIKit
import SnapKit

class HotPlaceCellHeader: UICollectionReusableView {
    
    static let identifier = "HotPlaceCellHeader"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addComponents()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property
    
    lazy var titleLabel = makeLabel(
        font: UIFont.notoSans(.bold, size: 16),
        .secondary
    )
    
    lazy var categoryLabel = makeLabel(
        font: .notoSans(.medium, size: 14),
        .captionGray
    )
    
    lazy var verificationCount = makeLabel(
        font: .notoSans(.medium, size: 14),
        .captionGray
    )
    
    lazy var saveCount = makeLabel(
        font: .notoSans(.medium, size: 14),
        .captionGray
    )
    
    private lazy var headerStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .equalSpacing
    }
    
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
    
    /// 헤더 셀 초기화 설정 함수
    public func configure(model: HotPlaceHeaderModel) {
        titleLabel.text = model.title
        categoryLabel.text = model.category
        verificationCount.text = model.verificationCount
        saveCount.text = model.saveCount
    }
    
    private func addComponents() {
        [
            titleLabel,
            categoryLabel,
            verificationCount,
            saveCount
        ].forEach {
            headerStack.addArrangedSubview($0)
        }
        addSubview(headerStack)
    }
    
    private func constraints() {
        let labelHeight: CGFloat = 20
        
        headerStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(150)
            make.height.equalTo(labelHeight)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(55)
            make.height.equalTo(labelHeight)
        }
        
        verificationCount.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(55)
            make.height.equalTo(labelHeight)
        }
        
        saveCount.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(55)
            make.height.equalTo(labelHeight)
        }
    }
    
}

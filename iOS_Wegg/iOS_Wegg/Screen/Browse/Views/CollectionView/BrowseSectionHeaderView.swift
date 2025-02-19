//
//  BrowseSectionHeaderView.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/17/25.
//

import UIKit
import SnapKit

/// 섹션 구분용 헤더뷰
class BrowseSectionHeaderView: UICollectionReusableView {
    let titleLabel = UILabel().then {
        $0.font = UIFont.notoSans(.medium, size: 16)
        $0.textColor = .customColor(.customGray2)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { $0.edges.equalToSuperview().inset(8) }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

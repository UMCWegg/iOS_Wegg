//
//  SectionSeparatorFooter.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/1/25.
//

import UIKit
import SnapKit

/// 컬렉션 뷰 커스텀 푸터 정의
class SectionSeparatorFooter: UICollectionReusableView {
    
    static let identifier: String = "SectionSeparatorFooter"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(separator)
        separator.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 구분선 생성
    lazy var separator = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
}

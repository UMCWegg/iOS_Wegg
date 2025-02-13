//
//  PlaceVerificationOverlayView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/13/25.
//

import UIKit

class PlaceVerificationOverlayView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// hitTest(_:with:)
    /// - 터치 이벤트를 처리할 최종 뷰 결정
    /// - 지도 위에서 제스처 필요한 버튼 추가
    /// - Returns: 터치 이벤트를 처리할 UIView(없을 경우 nil 반한)
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
    
    /// PlaceVerificationOverlayView의 기본 레이아웃 설정(전체 화면)
    func setupOverlayConstraints(in parentView: UIView) {
        parentView.addSubview(self)
        snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

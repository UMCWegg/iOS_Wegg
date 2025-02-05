//
//  OverlayLayout.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/31/25.
//

import Foundation

/// `MapOverlayViewLayout`
///
/// - 지도 화면의 오버레이와 바텀 시트의 레이아웃 설정을 위한 상수 구조체
/// - 오버레이 UI 컴포넌트(현재 위치 버튼, 검색 버튼, 바텀 시트 헤더 등)의 위치와 크기를 정의
/// - 레이아웃 값을 모듈화하여 코드 유지보수를 용이하게 함
struct MapViewLayout {
    static let initialBottomSheetHeight: CGFloat = 93
    static let yellowLogoIcon: CGFloat = 18
    
    struct CurrentLocation {
        static let leadingOffset: CGFloat = 327
        static let trailingOffset: CGFloat = -21
        static let bottomOffset: CGFloat = -21
        static let widthAndHeight: CGFloat = 42
    }
    
    struct PlaceSearch {
        static let leadingOffset: CGFloat = 327
        static let trailingOffset: CGFloat = -21
        static let topOffset: CGFloat = 10
        static let searchBarHeight: CGFloat = 130
    }
    
    struct BottomSheetHeader {
        static let topOffset: CGFloat = 47.5
        static let leadingOffset: CGFloat = 21
        static let trailingOffset: CGFloat = -21
        static let bottomOffset: CGFloat = -24
    }
    
    /// 바텀 시트 내부 컬력센 뷰 레이아웃
    struct BottomSheetContent {
        static let topOffset: CGFloat = 14
        static let bottomOffset: CGFloat = -10
    }
    
}

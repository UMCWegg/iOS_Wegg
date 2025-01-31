//
//  OverlayLayout.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/31/25.
//

import Foundation

/// MapOverlayViewLayout
struct MapViewLayout {
    static let initialBottomSheetHeight: CGFloat = 93
    struct CurrentLocation {
        static let leadingOffset: CGFloat = 327
        static let trailingOffset: CGFloat = -21
        static let bottomOffset: CGFloat = -21
    }
    struct PlaceSearch {
        static let leadingOffset: CGFloat = 327
        static let trailingOffset: CGFloat = -21
        static let topOffset: CGFloat = 10
    }
}

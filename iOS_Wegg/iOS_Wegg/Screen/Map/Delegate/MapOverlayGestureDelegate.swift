//
//  MapOverlayGestureDelegate.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/25/25.
//

import Foundation

/// `MapOverlayGestureDelegate.swift`
///
/// - Map 폴더 아래에 위치시킨 이유:
///     - `MapOverlayGestureDelegate`는 지도와 관련된 UI동작을 관리하는 Delegate이다.
///     - 따라서 UI 컴포넌트의 책임을 명확히 하기 위해 Map 폴더 아래에 위치
protocol MapOverlayGestureDelegate: AnyObject {
    func didDetectOnLocationButtonTapped()
    func didPlaceSearchButtonTapped()
}

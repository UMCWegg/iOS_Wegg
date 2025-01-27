//
//  MapOverlayGestureDelegate.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/25/25.
//

import Foundation

/// `MapOverlayGestureDelegate.swift`
///
/// - View 폴더 아래에 위치시킨 이유:
///     - `MapOverlayGestureDelegate`는 `MapOverlayView`와 강하게 연관된 역할을 한다
///     - View와 관련된 UI동작을 관리하는 Delegate로, UI 컴포넌트의 책임을 명확히 하기 위해  View 폴더 아래에 위치
protocol MapOverlayGestureDelegate: AnyObject {
    func didDetectOnLocationButtonTapped()
    func didPlaceSearchButtonTapped()
    func didHotPlaceListTapped()
}

//
//  MapSearchViewGestureDelegate.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/4/25.
//

import Foundation

/// `MapSearchViewGestureDelegate.swift`
///
/// - Map 폴더 아래에 위치시킨 이유:
///     - `MapSearchViewGestureDelegate`는 지도와 관련된 UI동작을 관리하는 Delegate이다.
///     - 따라서 UI 컴포넌트의 책임을 명확히 하기 위해 Map 폴더 아래에 위치
protocol MapSearchViewGestureDelegate: AnyObject {
    func didTapSearchBackButton()
    func didTapSearchButton()
}

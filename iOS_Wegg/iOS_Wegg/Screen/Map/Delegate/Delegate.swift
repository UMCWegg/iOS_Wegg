//
//  Delegate.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/7/25.
//

import Foundation

/// `Delegate.swift`
///
/// - 위치: Map/Delegate 폴더
/// - 이유:
///     - 아래의 Delegate들은 지도와 관련된 UI 동작을 관리한다.
///     - UI 컴포넌트의 책임을 명확히 하기 위해 Map 폴더 아래에 위치시킴.
protocol MapOverlayGestureDelegate: AnyObject {
    /// 현재 위치 탐지 버튼을 탭했을 때 호출.
    func didTapDetectOnLocationButton()
    
    /// 장소 검색 버튼을 탭했을 때 호출.
    func didTapPlaceSearchButton()
    
    /// 장소 검색 바를 탭했을 때 호출.
    func didTapPlaceSearchBar()
    
    /// 뒤로 가기 버튼을 탭했을 때 호출
    func didTapPlaceDetailBackButton()
    
    func didTapReloadButton()
}

protocol PlaceDetailViewGestureDelegate: AnyObject {
    /// 즐겨찾기 저장
    func didTapSavePlaceButton()
    
    /// 즐겨찾기 삭제
    func didTapDeletePlaceButton()
    
    /// "이 장소로 알 생성하기" 버튼을 탭했을 때 호출.
    func didTapPlaceCreateButton()
}

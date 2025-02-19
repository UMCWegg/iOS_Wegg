//
//  MapManagerProtocol.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/22/25.
//

import UIKit
import CoreLocation

/// 지도 공통 데이터 타입
struct Coordinate {
    let latitude: Double
    let longitude: Double
}

/// 최상위 프로토콜
protocol MapManagerProtocol {
    func setupMap(in view: UIView)
    func setupLocationManager()
    func moveCameraToLocation(_ location: CLLocation)
    func setTapGestureHandler(_ handler: @escaping (Coordinate) -> Void)
    func setLongTapGestureHandler(_ handler: @escaping (Coordinate) -> Void)
    func requestCurrentLocation()
    /// 마커 추가 (이미지 파일 기반)
    func addMarker(
        imageName: String,
        width: CGFloat,
        height: CGFloat,
        at coordinate: Coordinate
    )
    /// 마커 추가 (UIImage 기반)
    func addMarker(
        image: UIImage,
        width: CGFloat,
        height: CGFloat,
        at coordinate: Coordinate
    )
    /// 지도의 카메라 기준으로 경계값 가져옴
    func getVisibleBounds(sortBy: String?) -> HotPlaceRequest
    
    /// 현재 위치 정보를 반환하는 함수
    /// - Parameter completion: 위치 정보를 비동기적으로 반환하는 클로저
    ///
    /// 이 함수는 `currentLocation`이 이미 존재하는 경우 즉시 해당 값을 반환.
    /// 만약 위치 정보가 아직 업데이트되지 않았다면, `requestCurrentLocation()`을 호출하여
    /// 위치 정보를 요청한 후 `locationUpdateHandler`에 클로저를 저장하여
    /// 업데이트가 완료되면 클로저를 실행.
    func getCurrentLocation(completion: @escaping (Coordinate?) -> Void)
}

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
    /// 현재 위치 getter
    func getCurrentLocation() -> Coordinate?
}

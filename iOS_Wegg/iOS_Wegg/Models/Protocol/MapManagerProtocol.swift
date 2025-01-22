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
    func updateLocation(_ location: CLLocation)
    func setTapGestureHandler(_ handler: @escaping (Coordinate) -> Void)
    func setLongTapGestureHandler(_ handler: @escaping (Coordinate) -> Void)
}

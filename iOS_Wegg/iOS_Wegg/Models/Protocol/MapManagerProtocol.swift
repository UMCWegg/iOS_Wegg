//
//  MapManagerProtocol.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/22/25.
//

import UIKit
import CoreLocation

// MARK: - 지도 공통 데이터 타입

/// `Coordinate` 구조체는 위도와 경도를 나타내며, `Equatable`을 준수하여 비교 연산을 지원.
/// - `latitude`: 위도 (Double)
/// - `longitude`: 경도 (Double)
/// - `==` 연산자 오버로딩을 통해 미세한 차이(0.00001) 이내의 좌표를 동일한 위치로 판단.
struct Coordinate: Equatable {
    let latitude: Double
    let longitude: Double

    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        let tolerance: Double = 0.01 // 허용 오차 (위도/경도 비교 시 사용)
        return abs(lhs.latitude - rhs.latitude) < tolerance &&
               abs(lhs.longitude - rhs.longitude) < tolerance
    }
}

// MARK: - 지도 매니저 프로토콜

/// 지도 관련 기능을 정의한 프로토콜.
/// `MapKit`, `Naver Map SDK` 등 다양한 지도 API에 대한 공통 인터페이스를 제공.
protocol MapManagerProtocol {
    
    /// 지정된 뷰에 지도를 초기화.
    /// - Parameter view: 지도를 표시할 `UIView`
    func setupMap(in view: UIView)
    
    /// 위치 매니저를 설정하여 사용자 위치 정보를 관리.
    func setupLocationManager()
    
    /// 지정된 위치로 지도 카메라를 이동.
    /// - Parameter location: 이동할 `CLLocation`
    func moveCameraToLocation(_ location: CLLocation)
    
    /// 지도에서 탭 제스처가 감지될 때 실행할 핸들러를 설정.
    /// - Parameter handler: 탭한 좌표 (`Coordinate`)를 전달하는 클로저
    func setTapGestureHandler(_ handler: @escaping (Coordinate) -> Void)
    
    /// 지도에서 롱탭 제스처가 감지될 때 실행할 핸들러를 설정.
    /// - Parameter handler: 롱탭한 좌표 (`Coordinate`)를 전달하는 클로저
    func setLongTapGestureHandler(_ handler: @escaping (Coordinate) -> Void)
    
    /// 현재 사용자 위치를 요청.
    /// 내부적으로 `CLLocationManager`를 사용하여 위치 정보를 가져.
    func requestCurrentLocation()
    
    // MARK: - 마커 관리
    
    /// 특정 좌표에 마커를 추가. (이미지 파일 기반)
    /// - Parameters:
    ///   - imageName: 마커로 사용할 이미지 파일명 (`Assets`에 있는 이미지)
    ///   - width: 마커 너비 (`CGFloat`)
    ///   - height: 마커 높이 (`CGFloat`)
    ///   - coordinate: 마커를 표시할 `Coordinate`
    func addMarker(
        imageName: String,
        width: CGFloat,
        height: CGFloat,
        at coordinate: Coordinate
    )
    
    /// 특정 좌표에 마커를 추가. (`UIImage` 기반)
    /// - Parameters:
    ///   - image: 마커로 사용할 `UIImage`
    ///   - width: 마커 너비 (`CGFloat`)
    ///   - height: 마커 높이 (`CGFloat`)
    ///   - coordinate: 마커를 표시할 `Coordinate`
    func addMarker(
        image: UIImage,
        width: CGFloat,
        height: CGFloat,
        at coordinate: Coordinate
    )
    
    // MARK: - 지도 경계 관련
    
    /// 현재 지도 화면에서 보이는 영역의 경계값을 가져온다.
    /// - Parameter sortBy: 정렬 기준 (`"distance"` 또는 `"popularity"`, 기본값은 거리순)
    /// - Returns: `HotPlaceRequest` (서버 API 요청을 위한 데이터 모델)
    func getVisibleBounds(sortBy: String?) -> HotPlaceRequest
    
    // MARK: - 위치 정보 관리
    
    /// 현재 위치 정보를 반환하는 함수 (비동기 방식).
    /// - Parameter completion: 위치 정보를 반환하는 클로저 (`Coordinate?` 형태)
    ///
    /// 이 함수는 `currentLocation`이 이미 존재하는 경우 즉시 해당 값을 반환.
    /// 만약 위치 정보가 아직 업데이트되지 않았다면, `requestCurrentLocation()`을 호출하여
    /// 위치 정보를 요청한 후 `locationUpdateHandler`에 클로저를 저장하여
    /// 업데이트가 완료되면 클로저를 실행.
    func getCurrentLocation(completion: @escaping (Coordinate?) -> Void)
    
    // MARK: - 마커 관리
    
    /// 지도에 추가된 모든 마커를 제거.
    func removeAllMarkers()
}

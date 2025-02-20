//
//  PlaceVerificationViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/13/25.
//

import UIKit

class PlaceVerificationViewController: UIViewController {
    
    private let mapManager: MapManagerProtocol
    private lazy var placeVerificationOverlayView = PlaceVerificationOverlayView()
    private let apiManager = APIManager()
    
    private var checkVerificationResult: Bool? // 인증 가능 여부 저장
    private var currentLocation: Coordinate? // 현재 위치 정보 저장
    private var planId: Int // 일정 ID 저장
    
    // MARK: - Init
    
    /// `MapManagerProtocol`을 주입하여 지도 관리
    /// - Parameter mapManager: 지도 관련 기능을 담당하는 프로토콜
    /// - Parameter planId: 일정의 ID
    init(mapManager: MapManagerProtocol, planId: Int) { // TODO: 추후 planId 기본값 제거
        self.mapManager = mapManager
        self.planId = planId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    /// 화면이 나타나기 전에 지도 및 UI 초기화
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapManager.setupMap(in: view)
        setupOverlayView()
    }
    
    /// 화면이 로드될 때 쿠키를 설정하고 장소 인증 요청 실행
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPlaceVerificationInfo()
    }
    
    // MARK: - UI Setup
    
    /// 인증 오버레이 뷰를 설정하고 델리게이트 연결
    private func setupOverlayView() {
        placeVerificationOverlayView.setupOverlayConstraints(in: view)
        placeVerificationOverlayView.delegate = self
    }
    
    /// 현재 위치에 마커를 추가하는 함수
    /// - Parameter image: 마커로 사용할 이미지
    private func setupInfoMarker(image: UIImage) {
        mapManager.getCurrentLocation { [weak self] coordinate in
            guard let coordinate = coordinate else { return }
            self?.mapManager.addMarker(
                image: image,
                width: image.size.width,
                height: image.size.height,
                at: coordinate
            )
        }
    }
    
    // MARK: - Image Processing
    
    /// `placeVerificationOverlayView`를 이미지로 변환하여 마커로 추가
    private func convertToImage() {
        // placeVerificationOverlayView가 완전히 렌더링 된 후 변환 실행
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            var convertedImage: UIImage?
            self.placeVerificationOverlayView.layoutIfNeeded()
            convertedImage = self.placeVerificationOverlayView.placeVerificationInfoView.toImage()
            
            // 화면에 표시되는 placeVerificationInfoView를 투명하게 처리
            self.placeVerificationOverlayView.placeVerificationInfoView.alpha = 0
            
            if let image = convertedImage {
                print("변환된 이미지 크기: \(image.size.width) x \(image.size.height)")
                self.setupInfoMarker(image: image) // 마커 추가
            } else {
                print("변환된 이미지 없음")
            }
        }
    }
    
    // MARK: - API Calls
    
    /// 서버에서 장소 인증 정보를 가져와 현재 위치와 비교
    private func checkPlaceVerificationInfo() {
        Task {
            do {
                let response: FetchPlaceVerificationResponse = try await apiManager.request(
                    target: PlaceVerificationAPI.getkPlaceVerification(planId: planId)
                )
                let placeName = response.result.placeName
                let placeLocation = Coordinate(
                    latitude: response.result.latitude,
                    longitude: response.result.longitude
                )
                print("response: \(response)")
                // 가져온 장소 정보를 기반으로 현재 위치 검증 실행
                verifyUserLocation(with: placeLocation, placeName: placeName)
            } catch {
                print("PlaceVerificationCheckResponse 오류: \(error)")
            }
        }
    }
    
    /// 현재 위치와 등록된 장소의 위치를 비교하여 인증 가능 여부를 확인
    /// - Parameters:
    ///   - placeLocation: 서버에서 받아온 인증할 장소의 좌표
    ///   - placeName: 장소의 이름
    private func verifyUserLocation(with placeLocation: Coordinate, placeName: String) {
        mapManager.getCurrentLocation { [weak self] coordinate in
            guard let self = self,
                  let coordinate = coordinate else { return }
            currentLocation = coordinate

            // 현재 위치와 등록된 장소 위치 비교
            if currentLocation == placeLocation {
                checkVerificationResult = true
                placeVerificationOverlayView.toggleVerificationButton(isEnabled: true)
                DispatchQueue.main.async { [weak self] in
                    self?.placeVerificationOverlayView.configuration(
                        title: placeName,
                        subTitle: "시간이 다 되었습니다! 인증을 진행해주세요"
                    )
                    self?.convertToImage()
                }
            } else {
                checkVerificationResult = false
                placeVerificationOverlayView.toggleVerificationButton(isEnabled: false)
                DispatchQueue.main.async { [weak self] in
                    self?.placeVerificationOverlayView.configuration(
                        title: placeName,
                        subTitle: "등록된 장소로 이동해주세요!"
                    )
                    self?.convertToImage()
                }
            }
        }
    }
}

// MARK: - Delegate

extension PlaceVerificationViewController: PlaceVerificationOverlayViewDelegate {
    
    /// 인증하기 버튼을 누르면 인증 결과를 확인하고 서버에 인증 요청을 보낸 후 메인 화면으로 이동
    func didTapVerificationButton() {
        guard let verifyLocation = checkVerificationResult else { return }
        guard let currentLocation = currentLocation else {
            print("currentLocation is nil")
            return
        }
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            // alertVC가 닫힌 후 실행되도록 수정
            self.dismiss(animated: true) {
                let mainVC = MainTabBarController()
                mainVC.modalPresentationStyle = .fullScreen
                self.present(mainVC, animated: true)
            }
        }
        
        if verifyLocation {
            let request = CheckPlaceVerificationRequest(
                lat: currentLocation.latitude,
                lon: currentLocation.longitude
            )
            
            Task {
                do {
                    let res: CheckPlaceVerificationResponse = try await self.apiManager.request(
                        target: PlaceVerificationAPI.checkPlaceVerification(
                            planId: planId,
                            request: request
                        )
                    )
                    // 인증 성공 메시지 출력
                    showAlert(title: res.message, action: confirmAction)
                } catch {
                    print("CheckPlaceVerificationResponse 오류: \(error)")
                }
            }
        }
    }
}

// MARK: - Utility

private extension PlaceVerificationViewController {
    
    /// 경고(Alert) 창을 띄우는 유틸리티 함수
    /// - Parameters:
    ///   - title: 알림 제목
    ///   - message: 알림 메시지 (옵션)
    ///   - action: 알림에 추가할 액션
    func showAlert(title: String, message: String? = nil, action: UIAlertAction) {
        let alertVC = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
}

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
    
    private var checkVerificationResult: Bool?
    
    // MARK: - Init
    
    /// `MapManagerProtocol`을 주입하여 지도 관리
    init(mapManager: MapManagerProtocol) {
        self.mapManager = mapManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    /// 화면이 나타나기 전에 지도 및 UI 초기화
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mapManager.setupMap(in: view)
        setupOverlayView()
    }
    
    /// 화면이 로드될 때 쿠키를 설정하고 장소 인증 요청 실행
    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager.setCookie(value: CookieStorage.cookie)
        checkPlaceVerification()
    }
    
    // MARK: - UI Setup
    
    /// 인증 오버레이 뷰를 설정하고 제스처 델리게이트를 할당
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
            
            // 크기가 설정되어 화면에 나타나는 placeVerificationInfoView를 투명하게 설정
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
    private func checkPlaceVerification() {
        Task {
            do {
                let response: FetchPlaceVerificationResponse = try await apiManager.request(
                    target: PlaceVerificationAPI.getkPlaceVerification(planId: 78)
                )
                let placeName = response.result.placeName
                let placeLocation = Coordinate(
                    latitude: response.result.latitude,
                    longitude: response.result.longitude
                )
                
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
            guard let self = self else {
                print("self 없음")
                return
            }

            // 현재 위치와 등록된 장소 위치 비교
            if coordinate == placeLocation {
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
    
    /// 인증하기 버튼을 누르면 인증 결과를 확인하고 메인 화면으로 이동
    func didTapVerificationButton() {
        guard let checkVerificationResult = checkVerificationResult else { return }
        if checkVerificationResult {
            let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                // alertVC가 닫힌 후 실행되도록 수정
                self.dismiss(animated: true) {
                    let mainVC = MainTabBarController()
                    mainVC.modalPresentationStyle = .fullScreen
                    self.present(mainVC, animated: true)
                }
            }
            showAlert(title: "인증 성공!!", action: confirmAction)
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

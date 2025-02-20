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
    
    init(mapManager: MapManagerProtocol) {
        self.mapManager = mapManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mapManager.setupMap(in: view)
        setupOverlayView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager.setCookie(value: CookieStorage.cookie)
        checkPlaceVerification()
    }
    
    private func setupOverlayView() {
        placeVerificationOverlayView.setupOverlayConstraints(in: view)
        placeVerificationOverlayView.delegate = self
    }
    
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
    
    private func convertToImage() {
        // placeVerificationOverlayView가 완전히 렌더링 된 후 변환 실행
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            var convertedImage: UIImage?
            self.placeVerificationOverlayView.layoutIfNeeded()
            convertedImage = self.placeVerificationOverlayView.placeVerificationInfoView.toImage()
            // 크기가 설정되어 화면에 나타나는 placeVerificationInfoView를 투명하게 함
            self.placeVerificationOverlayView.placeVerificationInfoView.alpha = 0
            if let image = convertedImage {
                print("변환된 이미지 크기: \(image.size.width) x \(image.size.height)")
                self.setupInfoMarker(image: image) // 마커 추가
            } else {
                print("변환된 이미지 없음")
            }
        }
    }
    
    private func checkPlaceVerification() {
        Task {
            do {
                let response: PlaceVerificationCheckResponse = try await apiManager.request(
                    target: PlaceVerificationAPI.checkPlaceVerification(planId: 1)
                )
                print("PlaceVerificationCheckResponse: \(response.result)")
                let placeName = response.result.placeName
                let placeLocation = Coordinate(
                    latitude: response.result.latitude,
                    longitude: response.result.longitude
                )
                print(placeName, placeLocation)
                
                DispatchQueue.main.async { [weak self] in
                    self?.placeVerificationOverlayView.configuration(
                        title: placeName,
                        subTitle: "시간이 다 되었습니다! 인증을 진행해주세요"
                    )
                    self?.convertToImage()
                }
            } catch {
                print("PlaceVerificationCheckResponse 오류: \(error)")
            }
        }
    }
    
}

// MARK: - Delegate

extension PlaceVerificationViewController: PlaceVerificationOverlayViewDelegate {
    // 인증하기 버튼 누르면 인증 성공 여부 검사 후 메인으로 이동
    func didTapVerificationButton() {
        // [25.02.14] 추후 공부 일정에 등록된 장소 위치와 현재 위치 비교하는 로직 추가 필요
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            // alertVC가 닫힌 후 실행되도록 수정
            self.dismiss(animated: true) {
                let mainVC = MainTabBarController()
                mainVC.modalPresentationStyle = .fullScreen
                self.present(mainVC, animated: true)
            }
        }
        
        let alertVC = UIAlertController(
            title: "인증 성공!!",
            message: nil,
            preferredStyle: .alert
        )
        alertVC.addAction(confirmAction)
        present(alertVC, animated: true)
    }
    
}

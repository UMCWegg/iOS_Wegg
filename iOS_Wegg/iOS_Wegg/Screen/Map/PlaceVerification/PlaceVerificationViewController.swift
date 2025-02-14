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
    
    init(mapManager: MapManagerProtocol) {
        self.mapManager = mapManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapManager.setupMap(in: view)
        setupOverlayView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

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
    
    private func setupOverlayView() {
        placeVerificationOverlayView.setupOverlayConstraints(in: view)
        // 임시 데이터 초기화
        placeVerificationOverlayView.configuration(
            title: "스타벅스 신용산점",
            subTitle: "시간이 다 되었습니다! 인증을 진행해주세요"
        )
    }
    
    private func setupInfoMarker(image: UIImage) {
        // TODO: [25.02.14] 추후 공부 일정에 등록된 장소 위치로 변경 필요 - 작성자: 이재원
        guard let coordinate = mapManager.getCurrentLocation() else { return }

        mapManager.addMarker(
            image: image,
            width: image.size.width,
            height: image.size.height,
            at: coordinate
        )
    }
    
}

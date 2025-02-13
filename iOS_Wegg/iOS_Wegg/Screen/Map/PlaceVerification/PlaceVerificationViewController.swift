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
        // 임시 데이터 초기화
        placeVerificationOverlayView.configuration(
            title: "스타벅스 신용산점",
            subTitle: "시간이 다 되었습니다! 인증을 진행해주세요"
        )
    }
    
    private func setupOverlayView() {
        placeVerificationOverlayView.setupOverlayConstraints(in: view)
    }
    
}

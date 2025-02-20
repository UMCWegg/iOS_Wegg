//
//  PlaceDetailViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/5/25.
//

import UIKit
import FloatingPanel

class PlaceDetailViewController: UIViewController {
    weak var mapVC: MapViewController?
    var targetSectionIndex: Int = 3 // 모델에서 원하는 인덱스 설정
    private var collectionHandler: PlaceDetailCollectionHandler?
    private let sampleSections = HotPlaceSectionModel.sampleSections
    private var sectionModel: HotPlaceSectionModel?
    lazy var placeDetailView = PlaceDetailView()
    
    init(mapVC: MapViewController?) { // 생성자에서 의존성 주입
        self.mapVC = mapVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = placeDetailView
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionHandler = PlaceDetailCollectionHandler(
            targetSectionIndex: targetSectionIndex,
            sampleSections: sampleSections
        )
        placeDetailView.studyImageCollectionView.delegate = collectionHandler
        placeDetailView.studyImageCollectionView.dataSource = collectionHandler
        placeDetailView.gestureDelegate = self
    }
    
    /**
     메인 스레드에서 UI를 업데이트하는 함수
     - Parameter detail: `HotPlaceDetailModel` 데이터
     */
    @MainActor
    public func updateUI(with sectionModel: HotPlaceSectionModel) {
        
        let info = [
            placeDetailView.titleLabel: sectionModel.header.title,
            placeDetailView.categoryLabel: sectionModel.header.category,
            placeDetailView.addressLabel: sectionModel.header.address,
            placeDetailView.verificationCount: sectionModel.header.verificationCount,
            placeDetailView.saveCount: sectionModel.header.saveCount,
            placeDetailView.phoneNumberLabel: sectionModel.details?.phoneNumber
        ]
        
        info.forEach { $0.key.text = $0.value }
    }
}

extension PlaceDetailViewController: PlaceDetailViewGestureDelegate {
    func didTapFavoriteStar() {
        print("didTapFavoriteStar")
    }
    
    func didTapPlaceCreateButton() {
        print("didTapPlaceCreateButton")
    }
    
}

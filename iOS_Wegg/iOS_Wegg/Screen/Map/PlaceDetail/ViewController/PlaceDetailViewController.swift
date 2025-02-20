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
    private var collectionHandler: PlaceDetailCollectionHandler?
    private var sectionModel: HotPlaceSectionModel?
    lazy var placeDetailView = PlaceDetailView()
    private let apiManager = APIManager()
    
    init(sectionModel: HotPlaceSectionModel) { // 생성자에서 의존성 주입
        self.sectionModel = sectionModel
        print("sectionModel: \(sectionModel)")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = placeDetailView
        configureCollectionView()
        updateUI()
    }
    
    @MainActor
    private func configureCollectionView() {
        guard let sectionModel = sectionModel else { return }
        collectionHandler = PlaceDetailCollectionHandler(sectionModel: sectionModel)
        placeDetailView.studyImageCollectionView.delegate = collectionHandler
        placeDetailView.studyImageCollectionView.dataSource = collectionHandler
        placeDetailView.gestureDelegate = self
    }
    
    /**
     메인 스레드에서 UI를 업데이트하는 함수
     - Parameter detail: `HotPlaceDetailModel` 데이터
     */
    @MainActor
    public func updateUI() {
        guard let sectionModel = sectionModel else { return }
        DispatchQueue.main.async {
            let info = [
                self.placeDetailView.titleLabel: sectionModel.header.title,
                self.placeDetailView.categoryLabel: sectionModel.header.category,
                self.placeDetailView.addressLabel: sectionModel.header.address,
                self.placeDetailView.verificationCount: sectionModel.header.verificationCount,
                self.placeDetailView.saveCount: sectionModel.header.saveCount,
                self.placeDetailView.phoneNumberLabel: sectionModel.details?.phoneNumber
            ]
            
            info.forEach { $0.key.text = $0.value }
        }
    }
    
    /// 장소 저장 API 호출 함수
    private func saveHotPlace(addressId: Int) {
        Task {
            do {
                let response: SavePlaceResponse = try await apiManager.request(
                    target: HotPlacesAPI.savePlace(addressId: addressId)
                )
                print("response: \(response)")
            } catch {
                print("❌ 실패: \(error)")
            }
        }
    }
}

extension PlaceDetailViewController: PlaceDetailViewGestureDelegate {
    func didTapFavoriteStar() {
        print("didTapFavoriteStar")
        saveHotPlace(addressId: 1)
    }
    
    func didTapPlaceCreateButton() {
        print("didTapPlaceCreateButton")
    }
    
}

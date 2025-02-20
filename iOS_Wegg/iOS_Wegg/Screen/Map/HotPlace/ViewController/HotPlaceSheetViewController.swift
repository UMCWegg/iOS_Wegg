//
//  HotPlaceSheetViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/28/25.
//

import UIKit
import Then

class HotPlaceSheetViewController: UIViewController {
    /// `MapViewController`를 참조하도록 설정하여 FloatingPanel에 접근할 수 있도록 함
    weak var mapVC: MapViewController?
    private let apiManager: APIManager 
    private var hotPlaceSectionList: [HotPlaceSectionModel] = []
    
    init(mapVC: MapViewController?, apiManager: APIManager) { // 생성자에서 의존성 주입
        self.mapVC = mapVC
        self.apiManager = apiManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = hotPlaceView
    }
    
    lazy var hotPlaceView = HotPlaceSheetView().then {
        $0.delegate = self
        $0.hotPlaceCollectionView.delegate = self
        $0.hotPlaceCollectionView.dataSource = self
    }
    
    func updateHotPlaceList(_ list: [HotPlaceSectionModel]) {
        hotPlaceSectionList = list
        DispatchQueue.main.async {
            self.hotPlaceView.hotPlaceCollectionView.reloadData()
        }
    }
}

// MARK: - Delegate & DataSource Extenstion

extension HotPlaceSheetViewController:
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource {
    
    /// 섹션 갯수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return hotPlaceSectionList.count
    }
    
    /// 셀 아이템 갯수
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return hotPlaceSectionList[section].items.count
    }
    
    /// 셀 아이템 데이터 설정
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HotPlaceCell.identifier,
            for: indexPath
        ) as? HotPlaceCell else {
            fatalError("Could not dequeue HotPlaceCell")
        }
        
        // 데이터 접근 시 범위 확인
        let section = hotPlaceSectionList[indexPath.section]
        guard indexPath.row < section.items.count else {
            fatalError("Index out of range for section items")
        }
        let data = section.items[indexPath.row]
        cell.configure(model: data)
        
        return cell
    }
    
    /// 컬렉션 뷰의 행 사이 간격 설정
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 14
    }
    
    /// 같은 라인 내에서 아이템 간의 최소 간격 설정
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    /// 아이템 선택시 발생하는 이벤트 함수
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if indexPath.section == 0 && indexPath.item == 0 {
            print("이미지 컬렉션뷰 탭")
        }
    }
}

extension HotPlaceSheetViewController {
    /// 셀 헤더 데이터 & 푸터 설정
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HotPlaceCellHeader.identifier,
                for: indexPath
            ) as? HotPlaceCellHeader else {
                fatalError(
                    "\(HotPlaceCellHeader.identifier)의 식별자를 찾을 수 없습니다."
                )
            }
            header.gestureDelegate = self
            /// HotPlaceCellHeader의 각 섹션마다 데이터 주입
            let section = hotPlaceSectionList[indexPath.section]
            header.configure(model: section.header, indexPath: indexPath) // 셀 데이터 주입
            return header
            
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionSeparatorFooter.identifier,
                for: indexPath
            ) as? SectionSeparatorFooter else {
                fatalError("\(SectionSeparatorFooter.identifier)의 식별자를 찾을 수 없습니다.")
            }
            return footer
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50) // 적절한 크기 설정
    }
    
}

// MARK: - Delegate Extension

extension HotPlaceSheetViewController:
    HotPlaceCellGestureDelegate,
    HotPlaceSheetViewDelegate {
    
    func didTapHotPlaceCellHeader(at indexPath: IndexPath) {
        guard let mapVC = mapVC else { return }

        // 사용자가 탭한 셀의 섹션 데이터 가져오기
        let selectedSection = hotPlaceSectionList[indexPath.section]
        let placeName = selectedSection.header.title

        fetchDetailInfo(query: placeName, from: selectedSection) { updatedSection in
            DispatchQueue.main.async {
                let hotPlaceView = mapVC.hotPlaceSheetVC.hotPlaceView
                hotPlaceView.showBottomSheetComponents(isHidden: true)
                
                let placeDetailVC = PlaceDetailViewController(sectionModel: updatedSection)

                // FloatingPanel에서 새로운 장소 정보를 보여줌
                mapVC.floatingPanel.set(contentViewController: placeDetailVC)
                mapVC.floatingPanel.move(to: .full, animated: true)
                mapVC.overlayView.placeDetailBackButton.isHidden = false
            }
        }
    }
    
    func didTapDistanceButton() {
        guard let mapVC = mapVC else {
            print("Error: HotPlaceSheetVC's mapVC is nil")
            return
        }
        
        // REFACT: API 중복 호출 방지 필요
        mapVC.fetchHotPlacesFromVisibleBounds()
    }
    
    func didTapVerificationButton() {
        guard let mapVC = mapVC else {
            print("Error: HotPlaceSheetVC's mapVC is nil")
            return
        }
        // REFACT: API 중복 호출 방지 필요
        mapVC.fetchHotPlacesFromVisibleBounds(sortBy: "authCount")
    }
    
}

extension HotPlaceSheetViewController {
    
    // REFACTOR: MapSearchViewController와 중복이므로 리팩토링 필요
    /// 장소 상세 정보 API 가져오기 (비동기 데이터 반환)
    private func fetchDetailInfo(
        query: String,
        from section: HotPlaceSectionModel,
        completion: @escaping (HotPlaceSectionModel) -> Void
    ) {
        let request = HotplaceDetailInfoRequest(placeName: query)

        Task {
            do {
                let response: HotplaceDetailInfoResponse = try await apiManager.request(
                    target: HotPlacesAPI.getPlaceDetailInfo(request: request)
                )

                if let detail = response.result.detailList.first {
                    let updatedDetails = HotPlaceDetailModel(phoneNumber: detail.phone)

                    // 기존 헤더 정보 + address 추가
                    let updatedHeader = HotPlaceHeaderModel(
                        title: section.header.title,
                        category: section.header.category,
                        address: detail.roadAddress, // 🔹 API에서 받은 도로명 주소 반영
                        verificationCount: section.header.verificationCount,
                        saveCount: section.header.saveCount
                    )

                    // 기존 섹션에 새로운 상세 정보 및 주소 적용
                    var updatedSection = section
                    updatedSection.details = updatedDetails
                    updatedSection.header = updatedHeader

                    completion(updatedSection) // 최신 정보가 반영된 섹션 반환
                } else {
                    completion(section) // ❗ 상세 정보가 없는 경우 기존 섹션 반환
                }
            } catch {
                print("❌ 실패: \(error)")
                completion(section) // ❗ 실패 시 기존 섹션 반환
            }
        }
    }
}

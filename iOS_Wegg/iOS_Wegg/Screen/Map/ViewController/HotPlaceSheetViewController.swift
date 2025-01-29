//
//  HotPlaceSheetViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/28/25.
//

import UIKit
import Then

class HotPlaceSheetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view = hotPlaceView
    }
    
    private lazy var hotPlaceView = HotPlaceSheetView().then {
        $0.hotPlaceCollectionView.delegate = self
        $0.hotPlaceCollectionView.dataSource = self
    }
}

extension HotPlaceSheetViewController:
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return HotPlaceModel.sampleData.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HotPlaceCell.identifier,
                for: indexPath
            ) as? HotPlaceCell else {
                return UICollectionViewCell()
            }
            
            let data = HotPlaceModel.sampleData
            cell.configure(model: data[indexPath.row])
            
            return cell
        default:
            return UICollectionViewCell()
        }
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
}

extension HotPlaceSheetViewController {
    /// 섹션 갯수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
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
                    "Could not dequeue header with identifier \(HotPlaceCellHeader.identifier)"
                )
            }
            
            // Configure header with data if needed
            let headerData = HotPlaceHeaderModel.sampleDate[indexPath.section]
            header.configure(model: headerData)
            
            return header
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if indexPath.section == 0 && indexPath.item == 0 {
          print("이미지 컬렉션뷰 탭")
        }
      }
}

//
//  HotPlaceCell.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/28/25.
//

import UIKit
import SnapKit

class PlaceDetailImageCell: UICollectionViewCell {
    static let identifier = "PlaceDetailImageCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addComponents()
        constrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property
    
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
    }
    
    /// 이미지 셀 주입 함수
    public func configure(model: HotPlaceImageModel) {
        imageView.image = UIImage(named: model.imageName)
    }
    
    // MARK: Set up
    
    private func addComponents() {
        [imageView].forEach {
            addSubview($0)
        }
    }
    
    private func constrains() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

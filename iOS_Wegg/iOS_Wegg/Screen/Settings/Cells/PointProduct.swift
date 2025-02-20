//
//  PointProduct.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

import UIKit

import Then
import SnapKit

// 포인트 상품 모델
struct PointProduct {
    let id: String
    let title: String
    let price: Int
}

class PointProductCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.brown.cgColor
    }
    
    private let pointImageView = UIImageView().then {
        $0.image = UIImage(named: "point_icon") ?? UIImage(systemName: "circle.fill")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .systemYellow
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.notoSans(.medium, size: 16)
        $0.textColor = .black
    }
    
    private let priceLabel = UILabel().then {
        $0.font = UIFont.notoSans(.regular, size: 14)
        $0.textColor = .darkGray
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        
        [
            pointImageView,
            titleLabel,
            priceLabel
        ].forEach { containerView.addSubview($0) }
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview()
        }
        
        pointImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(pointImageView.snp.trailing).offset(15)
            make.top.equalToSuperview().offset(15)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    // MARK: - Configure
    
    func configure(with product: PointProduct) {
        titleLabel.text = product.title
        priceLabel.text = "\(product.price)원"
    }
}

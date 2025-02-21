//
//  PointPurchaseView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

import UIKit

import Then
import SnapKit

class PointPurchaseView: UIView {
    
    // MARK: - Properties
    
    let pointLabel = UILabel().then {
        $0.font = UIFont.notoSans(.medium, size: 18)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    private let pointIconView = UIImageView().then {
        $0.image = UIImage(named: "point_icon")
        $0.contentMode = .scaleAspectFit
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .yellowBg
        
        [
            pointLabel,
            tableView
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        pointLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(pointLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
        }
    }

}

//
//  StudyTimeCell.swift
//  iOS_Wegg
//
//  Created by KKM on 2/1/25.
//

import UIKit
import SnapKit
import Then

class StudyTimeCell: UICollectionViewCell {
    
    static let identifier = "StudyTimeCell"
    
    // MARK: - UI Components
    private let studyTimeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .secondary
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        contentView.backgroundColor = .yellowWhite
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.secondary.cgColor
        contentView.layer.borderWidth = 1
        
        contentView.addSubview(studyTimeLabel)
        
        studyTimeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(4)
        }
    }
    
    // MARK: - Configure Method
    func configure(studyTime: String) {
        if studyTime.isEmpty {
            studyTimeLabel.text = ""
            contentView.backgroundColor = .clear // 공부 기록 없는 날은 배경 투명
            contentView.layer.borderWidth = 0
        } else {
            studyTimeLabel.text = studyTime
            contentView.backgroundColor = .yellowWhite // 공부 기록 있는 날만 배경 설정
            contentView.layer.borderWidth = 1
        }
    }
}

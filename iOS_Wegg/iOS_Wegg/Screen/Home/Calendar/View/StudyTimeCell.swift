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
    // MARK: - Identifier
    static let identifier = "StudyTimeCell"
    
    // MARK: - UI Components
    private let studyLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .secondary
        $0.textAlignment = .center
        $0.numberOfLines = 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(studyLabel)
        contentView.backgroundColor = .yellowWhite
        contentView.layer.cornerRadius = 12
    }
    
    private func setupLayout() {
        studyLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
    
    func configure(with studyTime: String) {
        studyLabel.text = studyTime
    }
}

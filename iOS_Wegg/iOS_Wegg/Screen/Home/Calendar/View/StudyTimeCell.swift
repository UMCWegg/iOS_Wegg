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
    private let eggImageView = UIImageView().then {
        $0.image = UIImage(named: "emptyEgg")
        $0.contentMode = .scaleAspectFit
    }

    private let studyTimeLabel = UILabel().then {
        $0.font = .notoSans(.regular, size: 12)
        $0.textAlignment = .center
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.8
        $0.textColor = .secondary
        $0.numberOfLines = 0
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
        contentView.addSubview(eggImageView)
        contentView.addSubview(studyTimeLabel)
    }

    private func setupLayout() {
        eggImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        studyTimeLabel.snp.makeConstraints {
            $0.center.equalTo(eggImageView)
            $0.width.equalTo(eggImageView.snp.width).multipliedBy(0.8)
            $0.height.equalTo(eggImageView.snp.height).multipliedBy(0.6)
        }
    }

    func configure(day: String, studyTime: String?) {
        if day.isEmpty {
            eggImageView.isHidden = true
            studyTimeLabel.text = ""
            return
        }

        eggImageView.isHidden = false
        if let studyTime = studyTime {
            studyTimeLabel.text = studyTime.replacingOccurrences(of: " ", with: "\n")
            eggImageView.image = UIImage(named: "fillEgg")
        } else {
            studyTimeLabel.text = ""
            eggImageView.image = UIImage(named: "emptyEgg")
        }
    }
}

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

    func configure(day: String, studyTime: String?, hasPlan: Bool?, hasFailedPlan: Bool?) {
        if day.isEmpty {
            eggImageView.isHidden = true
            studyTimeLabel.isHidden = true  // Hide label when the day is empty
            return
        }

        eggImageView.isHidden = false
        studyTimeLabel.isHidden = false // Ensure label is visible when the day is not empty

        if hasPlan == nil { // 계획이 없는 경우
            eggImageView.image = UIImage(named: "emptyEgg")
            studyTimeLabel.text = ""
        } else if hasFailedPlan == true { // 실패한 계획
            eggImageView.image = UIImage(named: "brokenEgg")
            studyTimeLabel.text = ""
        } else { // 성공한 계획 또는 계획이 있는 경우
            eggImageView.image = UIImage(named: "fillEgg")
            if let studyTime = studyTime, !studyTime.isEmpty {
                studyTimeLabel.text = formatStudyTime(studyTime)
            } else {
                studyTimeLabel.text = "0M"
            }

        }
    }

    // "1" -> "0H 1M" 형식으로 변환
    private func formatStudyTime(_ studyTime: String) -> String {
        guard let time = Int(studyTime) else { return "0H\n0M" }
        let hours = time / 60
        let minutes = time % 60
        return String(format: "%dH\n%dM", hours, minutes)
    }
}

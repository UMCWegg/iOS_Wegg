//
//  CalendarCell.swift
//  iOS_Wegg
//

import UIKit
import SnapKit
import Then

class CalendarCell: UICollectionViewCell {
    
    // MARK: - Identifier
    static let identifier = "CalendarCell"
    
    // MARK: - UI Components
    private let eggImageView = UIImageView().then {
        $0.image = UIImage(named: "emptyEgg")
        $0.contentMode = .scaleAspectFit
    }
    
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .secondary
        $0.textAlignment = .center
        $0.numberOfLines = 1 // ✅ 한 줄로 제한 (줄넘김 방지)
        $0.adjustsFontSizeToFitWidth = true // ✅ 글자가 커지더라도 크기에 맞춤
    }
    
    private let circleView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.secondary.cgColor
        $0.layer.cornerRadius = 12
        $0.isHidden = true
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
        contentView.addSubview(circleView)
        contentView.addSubview(dateLabel)
    }
    
    private func setupLayout() {
        eggImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        circleView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        dateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9) // ✅ 가로 너비 제한 추가 (요일 줄넘김 방지)
        }
    }

    func configure(day: String, isWeekday: Bool = false, isToday: Bool = false) {
        dateLabel.text = day
        circleView.isHidden = !isToday
        
        if isWeekday {
            eggImageView.isHidden = true
        } else {
            eggImageView.isHidden = false
            eggImageView.image = UIImage(named: "emptyEgg")
        }
    }
}

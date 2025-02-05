//
//  CalendarCell.swift
//  iOS_Wegg
//

import UIKit
import SnapKit
import Then

class CalendarCell: UICollectionViewCell {
    
    static let identifier = "CalendarCell"
    
    // MARK: - UI Components
    private let eggImageView = UIImageView().then {
        $0.image = UIImage(named: "emptyEgg")
        $0.contentMode = .scaleAspectFit
    }
    
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textAlignment = .center
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.8
    }
    
    private let circleView = UIView().then {
        $0.layer.borderWidth = 1.5
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
            $0.width.height.equalTo(24)
        }
    }

    func configure(day: String, isWeekday: Bool = false, isToday: Bool = false) {
        dateLabel.text = day
        
        if day.isEmpty {
            eggImageView.isHidden = true
            circleView.isHidden = true
            dateLabel.text = ""
            return
        }
        
        if isToday {
            circleView.backgroundColor = .clear
            circleView.layer.borderColor = UIColor.secondary.cgColor
            circleView.isHidden = false
            dateLabel.textColor = .secondary
        } else {
            circleView.backgroundColor = .clear
            circleView.layer.borderColor = UIColor.secondary.cgColor
            circleView.isHidden = true
            dateLabel.textColor = isWeekday ? .secondary : .black
        }
        
        eggImageView.isHidden = isWeekday
        dateLabel.font = isWeekday ? .notoSans(.bold, size: 12) : .notoSans(.regular, size: 14)
    }
}

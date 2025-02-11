//
//  ScheduleCalendarCell.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/11/25.
//

import UIKit
import SnapKit

class ScheduleCalendarCell: UICollectionViewCell {
    static let identifier = "ScheduleCalendarCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        setupView()
    }
    
    /// 셀이 재사용 될 때 이전 상태를 초기화하여 불필요한 UI 잔상 방지
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
        fillEggImageView.isHidden = true
        emptyEggImageView.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var label = UILabel().then {
        $0.textAlignment = .center
        $0.font = .notoSans(.medium, size: 16)
    }
    
    private lazy var fillEggImageView = UIImageView().then {
        $0.image = UIImage(named: "fillEgg")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var emptyEggImageView = UIImageView().then {
        $0.image = UIImage(named: "emptyEgg")
        $0.contentMode = .scaleAspectFit
    }

    func configure(date: Int?, isSelected: Bool) {
        label.text = date.map { "\($0)" }
        if date == nil {
            contentView.isHidden = true
            fillEggImageView.isHidden = true
        } else {
            contentView.isHidden = false
            fillEggImageView.isHidden = !isSelected
            emptyEggImageView.isHidden = isSelected
        }
    }
    
    private func setupView() {
        [fillEggImageView, emptyEggImageView].forEach { image in
            contentView.addSubview(image)
            image.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(42)
                make.height.equalTo(47)
            }
        }
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

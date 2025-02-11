//
//  ScheduleCalendarView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/11/25.
//

import UIKit
import Then

class ScheduleCalendarView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .primary
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var weekdayStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 25
    }
    
    lazy var calendarCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { _, _ in
            self.createCalendarLayout()
        }
    ).then {
        $0.backgroundColor = .clear
        $0.register(
            ScheduleCalendarCell.self,
            forCellWithReuseIdentifier: ScheduleCalendarCell.identifier
        )
    }
    
    private func createCalendarLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(50),
            heightDimension: .absolute(55)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(70)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 7
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 20, leading: 21, bottom: 25, trailing: 21
        )

        return section
    }
}

private extension ScheduleCalendarView {
    func setupView() {
        addComponents()
        constraints()
        setupWeekdays()
    }
    
    func addComponents() {
        [weekdayStackView, calendarCollectionView].forEach(addSubview)
    }
    
    func constraints() {
        weekdayStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(35)
            make.height.equalTo(30)
        }
        
        calendarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(weekdayStackView.snp.bottom).offset(35)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func setupWeekdays() {
        let weekdays: [String] = ["일", "월", "화", "수", "목", "금", "토"]
        
        weekdays.forEach { day in
            let label = UILabel()
            label.text = day
            label.textAlignment = .center
            label.font = .notoSans(.bold, size: 14)
            label.textColor = .secondary
            weekdayStackView.addArrangedSubview(label)
        }
    }
}

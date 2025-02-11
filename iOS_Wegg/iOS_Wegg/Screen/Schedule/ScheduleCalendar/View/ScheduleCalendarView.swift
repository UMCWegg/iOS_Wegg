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
    
    lazy var calendarCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { _, _ in
            self.createCalendarLayout()
        }
    ).then {
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
    }
    
    func addComponents() {
        addSubview(calendarCollectionView)
    }
    
    func constraints() {
        calendarCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

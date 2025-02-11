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
    
    // MARK: - Property
    
    private lazy var previousButton = UIButton().then {
        $0.setImage(UIImage(named: "previous"), for: .normal)
        $0.tintColor = .secondary
    }
    
    private lazy var yearMonthLabel = UILabel().then {
        $0.font = .notoSans(.medium, size: 20)
        $0.textColor = .secondary
        $0.textAlignment = .center
    }
    
    private lazy var nextButton = UIButton().then {
        $0.setImage(UIImage(named: "next"), for: .normal)
        $0.tintColor = .secondary
    }
    
    // previousButton + yearMonthLabel + yearMonthLabel
    private lazy var headerStackView = makeStackView(15, .horizontal, .equalSpacing)
    private lazy var weekdayStackView = makeStackView(25, .horizontal, .fillEqually)
    
    lazy var calendarCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { _, _ in
            self.createCalendarLayout()
        }
    ).then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.register(
            ScheduleCalendarCell.self,
            forCellWithReuseIdentifier: ScheduleCalendarCell.identifier
        )
    }
    
    private lazy var doneButton = makeButton("확인")
    private lazy var cancelButton = makeButton("취소")
    
    // MARK: - Function
    
    private func createCalendarLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(50),
            heightDimension: .absolute(55)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(65)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 7
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 21, bottom: 0, trailing: 21
        )

        return section
    }
    
    public func updateCalendar(date: String) {
        yearMonthLabel.text = date
    }
    
    // MARK: - Utility Functions
    
    /// UIStackView 생성 함수
    private func makeStackView(
        _ spacing: CGFloat,
        _ axis: NSLayoutConstraint.Axis,
        _ distribution: UIStackView.Distribution = .fill
    ) -> UIStackView {
        return UIStackView().then {
            $0.axis = axis
            $0.spacing = spacing
            $0.distribution = distribution
        }
    }
    
    private func makeButton(
        _ title: String
    ) -> UIButton {
        return UIButton().then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(.secondary, for: .normal)
            $0.titleLabel?.font = .notoSans(.medium, size: 16)
        }
    }
}

private extension ScheduleCalendarView {
    func setupView() {
        addComponents()
        constraints()
        setupWeekdays()
    }
    
    func addComponents() {
        [
            headerStackView,
            weekdayStackView,
            calendarCollectionView,
            doneButton,
            cancelButton
        ].forEach(addSubview)
        
        [previousButton, yearMonthLabel, nextButton].forEach {
            if $0 == yearMonthLabel {
                $0.snp.makeConstraints { make in
                    make.width.equalTo(105)
                }
            } else {
                $0.snp.makeConstraints { make in
                    make.width.equalTo(25)
                }
            }
            headerStackView.addArrangedSubview($0)
        }
        
    }
    
    func constraints() {
        headerStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19)
            make.leading.trailing.equalToSuperview().inset(93)
            make.height.equalTo(25)
        }
        
        weekdayStackView.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(19)
            make.leading.trailing.equalToSuperview().inset(35)
            make.height.equalTo(17)
        }
        
        calendarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(weekdayStackView.snp.bottom).offset(19)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(313)
        }
        
        [doneButton, cancelButton].forEach { button in
            button.snp.makeConstraints { make in
                if button == doneButton {
                    make.trailing.lessThanOrEqualToSuperview().offset(-21)
                } else {
                    make.leading.lessThanOrEqualToSuperview().offset(21)
                }
                make.top.equalTo(calendarCollectionView.snp.bottom).offset(22)
                make.width.equalTo(30)
            }
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

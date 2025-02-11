//
//  ScheduleCalendarView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/11/25.
//

import UIKit
import Then

class ScheduleCalendarView: UIView {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .primary
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    private lazy var prevMonthButton = UIButton().then {
        $0.setImage(UIImage(named: "previous"), for: .normal)
        $0.tintColor = .secondary
    }
    
    /// 현재 연/월을 표시하는 라벨 (예: "2025년 2월")
    private lazy var currentMonthLabel = UILabel().then {
        $0.font = .notoSans(.medium, size: 20)
        $0.textColor = .secondary
        $0.textAlignment = .center
    }
    
    private lazy var nextMonthButton = UIButton().then {
        $0.setImage(UIImage(named: "next"), for: .normal)
        $0.tintColor = .secondary
    }
    
    /// 헤더 스택뷰 (이전 버튼 + 현재 월 라벨 + 다음 버튼)
    private lazy var headerStackView = makeStackView(
        spacing: 15, axis: .horizontal, distribution: .equalSpacing
    )
    
    /// 요일 표시 스택뷰 (일 ~ 토)
    private lazy var weekdayStackView = makeStackView(
        spacing: 25, axis: .horizontal, distribution: .fillEqually
    )
    
    /// 캘린더 컬렉션 뷰 (날짜 표시)
    lazy var calendarCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { _, _ in
            self.createCalendarLayout()
        }
    ).then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false // 고정된 캘린더 UI 유지
        $0.register(
            ScheduleCalendarCell.self,
            forCellWithReuseIdentifier: ScheduleCalendarCell.identifier
        )
    }
    
    private lazy var confirmButton = makeButton(title: "확인")
    private lazy var cancelButton = makeButton(title: "취소")

    // MARK: - Public Functions
    
    /// 📌 현재 연/월 라벨을 업데이트하는 함수
    /// - Parameter date: "yyyy년 M월" 형식의 문자열
    public func updateCalendar(date: String) {
        currentMonthLabel.text = date
    }
    
    // MARK: - Private Functions
    
    /// 📌 캘린더 컬렉션 뷰의 레이아웃을 설정하는 함수
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
    
    // MARK: - Utility Functions
    
    /// 스택뷰 생성 함수
    private func makeStackView(
        spacing: CGFloat,
        axis: NSLayoutConstraint.Axis,
        distribution: UIStackView.Distribution = .fill
    ) -> UIStackView {
        return UIStackView().then {
            $0.axis = axis
            $0.spacing = spacing
            $0.distribution = distribution
        }
    }
    
    /// 버튼 생성 함수
    private func makeButton(title: String) -> UIButton {
        return UIButton().then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(.secondary, for: .normal)
            $0.titleLabel?.font = .notoSans(.medium, size: 16)
        }
    }
}

// MARK: - Set UP Extension

private extension ScheduleCalendarView {
    
    func setupView() {
        addComponents()
        constraints()
        setupWeekdayLabels()
    }
    
    func addComponents() {
        [
            headerStackView,
            weekdayStackView,
            calendarCollectionView,
            confirmButton,
            cancelButton
        ].forEach(addSubview)
        
        [prevMonthButton, currentMonthLabel, nextMonthButton].forEach {
            if $0 == currentMonthLabel {
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
        
        [confirmButton, cancelButton].forEach { button in
            button.snp.makeConstraints { make in
                if button == confirmButton {
                    make.trailing.lessThanOrEqualToSuperview().offset(-21)
                } else {
                    make.leading.lessThanOrEqualToSuperview().offset(21)
                }
                make.top.equalTo(calendarCollectionView.snp.bottom).offset(22)
                make.width.equalTo(30)
            }
        }
    }
    
    /// 요일 라벨 설정
    func setupWeekdayLabels() {
        let weekdays: [String] = ["일", "월", "화", "수", "목", "금", "토"]
        
        weekdays.forEach { day in
            let label = configureWeekdayLabel(day)
            weekdayStackView.addArrangedSubview(label)
        }
    }
    
    /// 요일 라벨을 생성하는 메서드 (반복 코드 제거)
    private func configureWeekdayLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = .notoSans(.bold, size: 12)
        label.textColor = .secondary
        return label
    }
}

//
//  ScheduleCalendarViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/11/25.
//

import UIKit

class ScheduleCalendarViewController: UIViewController {
    private var dates: [String?] = [] // 날짜 배열 (요일 포함)
    private var selectedDates = Set<Int>() // 선택된 날짜 저장
    private let calendarManager: CalendarManager = CalendarManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = scheduleCalendarView
        
        setupDates(
            for: calendarManager.getYear(),
            month: calendarManager.getMonth()
        )
    }
    
    lazy var scheduleCalendarView = ScheduleCalendarView().then {
        $0.calendarCollectionView.dataSource = self
        $0.calendarCollectionView.delegate = self
        $0.updateCalendar(date: calendarManager.getFormattedDate())
    }

    private func setupDates(for year: Int, month: Int) {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: 1)
        
        guard let firstDate = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: firstDate)
        else { return }

        let firstWeekday = calendar.component(.weekday, from: firstDate)
        dates = Array(repeating: nil, count: firstWeekday - 1) + range.map { "\($0)" }
    }
}

// MARK: - UICollectionViewDataSource

extension ScheduleCalendarViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return dates.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ScheduleCalendarCell.identifier,
            for: indexPath
        ) as? ScheduleCalendarCell else {
            return UICollectionViewCell()
        }

        if let dateString = dates[indexPath.item],
           let day = Int(dateString) {
            cell.configure(date: day, isSelected: selectedDates.contains(day))
        } else {
            cell.configure(date: nil, isSelected: false)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ScheduleCalendarViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let dateString = dates[indexPath.item],
              let date = Int(dateString) else { return }
        if selectedDates.contains(date) {
            selectedDates.remove(date)
        } else {
            selectedDates.insert(date)
        }
        collectionView.reloadItems(at: [indexPath])
    }
}

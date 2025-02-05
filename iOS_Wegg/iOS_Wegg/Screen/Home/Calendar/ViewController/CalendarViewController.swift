//
//  CalendarViewController.swift
//  iOS_Wegg
//

import UIKit

class CalendarViewController: UIViewController {
    
    let calendarView = CalendarView()
    private var days: [String] = []
    private let calendar = Calendar.current
    private var currentDate = Date()
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy년 M월"
    }

    override func loadView() {
        view = calendarView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupButtonActions()
        generateCalendar()
    }
    
    private func setupCollectionView() {
        calendarView.calendarCollectionView.dataSource = self
        calendarView.calendarCollectionView.delegate = self
    }
    
    private func setupButtonActions() {
        calendarView.previousButton.addTarget(
            self,
            action: #selector(previousMonth),
            for: .touchUpInside
        )
        calendarView.nextButton.addTarget(
            self,
            action: #selector(nextMonth),
            for: .touchUpInside
        )
    }
    
    @objc private func previousMonth() {
        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
        generateCalendar()
    }
    
    @objc private func nextMonth() {
        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
        generateCalendar()
    }
    
    private func generateCalendar() {
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        guard let startDate = calendar.date(from: components),
              let monthRange = calendar.range(of: .day, in: .month, for: startDate) else { return }

        let firstWeekday = calendar.component(.weekday, from: startDate)
        let totalDays = monthRange.count
        let offset = 2 - firstWeekday

        days.removeAll()
        for day in offset..<(42 + offset) {
            if day < 1 || day > totalDays {
                days.append("")
            } else {
                days.append("\(day)")
            }
        }

        calendarView.monthLabel.text = dateFormatter.string(from: currentDate)
        calendarView.calendarCollectionView.reloadData()
    }
}

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarCell.identifier,
            for: indexPath
        ) as? CalendarCell else { return UICollectionViewCell() }
        
        let isToday: Bool = {
            let currentComponents = calendar.dateComponents([.year, .month, .day], from: Date())
            let cellComponents = calendar.dateComponents([.year, .month], from: currentDate)
            guard let currentDay = currentComponents.day,
                  let cellDay = Int(days[indexPath.row]) else {
                return false
            }
            return currentComponents.year == cellComponents.year &&
                   currentComponents.month == cellComponents.month &&
                   cellDay == currentDay
        }()
        
        cell.configure(day: days[indexPath.row], isToday: isToday)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 12) / 7
        return CGSize(width: width, height: width * 1.2)
    }
}

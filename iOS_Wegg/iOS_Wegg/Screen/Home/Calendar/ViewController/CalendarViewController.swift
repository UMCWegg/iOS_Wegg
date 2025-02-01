//
//  CalendarViewController.swift
//  iOS_Wegg
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDataSource {
    
    private let calendarView = CalendarView()
    private var studyTimes: [String] = ["1시간", "2시간", "3시간"] // 샘플 데이터
    private var days: [String] = []
    private var weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    
    private let now = Date()
    private var cal = Calendar.current
    private let dateFormatter = DateFormatter()
    private var components = DateComponents()
    private var daysCountInMonth = 0
    private var weekdayAdding = 0
    private var todayDate: Int = 0

    override func loadView() {
        view = calendarView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.calendarCollectionView.dataSource = self
        calendarView.studyTimeCollectionView.dataSource = self
        
        calendarView.toggleButton.onToggleChanged = { [weak self] isOn in
            self?.calendarView.calendarCollectionView.isHidden = isOn
            self?.calendarView.studyTimeCollectionView.isHidden = !isOn
        }

        calendarView.previousButton.addTarget(
            self,
            action: #selector(previousMonthTapped),
            for: .touchUpInside
        )
        calendarView.nextButton.addTarget(
            self,
            action: #selector(nextMonthTapped),
            for: .touchUpInside
        )
        
        dateFormatter.dateFormat = "yyyy년 M월"
        components.year = cal.component(.year, from: now)
        components.month = cal.component(.month, from: now)
        components.day = 1
        todayDate = cal.component(.day, from: now)

        generateCalendarDays()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @objc private func previousMonthTapped() {
        components.month = (components.month ?? 1) - 1
        generateCalendarDays()
        calendarView.calendarCollectionView.reloadData()
    }
    
    @objc private func nextMonthTapped() {
        components.month = (components.month ?? 1) + 1
        generateCalendarDays()
        calendarView.calendarCollectionView.reloadData()
    }
    
    private func generateCalendarDays() {
        guard let firstDayOfMonth = cal.date(from: components) else {
            print("⚠️ Failed to create first day of the month")
            return
        }
        
        let firstWeekday = cal.component(.weekday, from: firstDayOfMonth)
        daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth)?.count ?? 0
        weekdayAdding = 2 - firstWeekday
        
        calendarView.monthLabel.text = dateFormatter.string(from: firstDayOfMonth)
        
        days.removeAll()
        for day in weekdayAdding...daysCountInMonth {
            if day < 1 {
                days.append("")
            } else {
                days.append(String(day))
            }
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        if collectionView == calendarView.calendarCollectionView {
            return section == 0 ? weeks.count : days.count
        } else {
            return studyTimes.count
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == calendarView.calendarCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CalendarCell.identifier, for: indexPath
            ) as? CalendarCell else {
                return UICollectionViewCell()
            }
            
            switch indexPath.section {
            case 0:
                cell.configure(day: weeks[indexPath.row], isWeekday: true)
            default:
                let isToday = days[indexPath.row] == String(todayDate)
                cell.configure(day: days[indexPath.row], isToday: isToday)
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StudyTimeCell.identifier, for: indexPath
            ) as? StudyTimeCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: studyTimes[indexPath.row])
            return cell
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let totalSpacing: CGFloat = 40 // 기존 48에서 감소하여 여백 줄이기
        let width = (collectionView.frame.width - totalSpacing) / 7

        if indexPath.section == 0 {
            return CGSize(width: width * 1.15, height: width * 0.9) // 요일 셀 크기 증가
        } else {
            return CGSize(width: width, height: width)
        }
    }
}

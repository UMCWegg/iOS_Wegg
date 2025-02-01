//
//  CalendarViewController.swift
//  iOS_Wegg
//

import UIKit

class CalendarViewController:
    UIViewController,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    
    private let calendarView = CalendarView()
    private var days: [String] = []
    private var weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    
    private let now = Date()
    private var cal = Calendar.current
    private let dateFormatter = DateFormatter()
    private var components = DateComponents()
    private var daysCountInMonth = 0
    private var weekdayAdding = 0
    private var todayDate: Int = 0  // 오늘 날짜 저장
    
    override func loadView() {
        view = calendarView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.calendarCollectionView.delegate = self
        calendarView.calendarCollectionView.dataSource = self
        
        calendarView.headerView.viewController = self
        calendarView.headerView.updateHeaderMode(isHomeMode: false)
        
        calendarView.calendarCollectionView.register(
            CalendarCell.self,
            forCellWithReuseIdentifier: CalendarCell.identifier
        )
        
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
        todayDate = cal.component(.day, from: now)  // 오늘 날짜 저장
        
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
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CalendarViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return weeks.count
        default:
            return days.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarCell.identifier,
            for: indexPath) as? CalendarCell else {
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
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 48
        let width = (collectionView.frame.width - totalSpacing) / 7
        
        return CGSize(width: width, height: width)
    }
}

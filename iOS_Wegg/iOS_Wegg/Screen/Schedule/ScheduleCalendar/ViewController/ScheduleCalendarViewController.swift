//
//  ScheduleCalendarViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/11/25.
//

import UIKit

class ScheduleCalendarViewController: UIViewController {
    
    weak var parentVC: AddScheduleViewController? // 부모 뷰 컨트롤러 저장
    
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
        $0.gestureDelegate = self
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

extension ScheduleCalendarViewController: ScheduleCalendarViewDelegate {
    func didTapPrevMonthButton() {
        selectedDates.removeAll()
        calendarManager.goToPreviousMonth()
        setupDates(
            for: calendarManager.getYear(),
            month: calendarManager.getMonth()
        )
        DispatchQueue.main.async { [weak self] in
            guard let date = self?.calendarManager.getFormattedDate() else { return }
            self?.scheduleCalendarView.updateCalendar(date: date)
            self?.scheduleCalendarView.calendarCollectionView.reloadData()
        }
    }
    
    func didTapNextMonthButton() {
        selectedDates.removeAll()
        calendarManager.goToNextMonth()
        setupDates(
            for: calendarManager.getYear(),
            month: calendarManager.getMonth()
        )
        DispatchQueue.main.async { [weak self] in
            guard let date = self?.calendarManager.getFormattedDate() else { return }
            self?.scheduleCalendarView.updateCalendar(date: date)
            self?.scheduleCalendarView.calendarCollectionView.reloadData()
        }
    }
    
    func didTapCancelButton() {
        selectedDates.removeAll()
        dismiss(animated: true)
    }
    
    func didTapConfirmButton() {
        // 23, 34, 30 과 같은 형태로 문자열 변환
        let translateSelectedDate = selectedDates.isEmpty ? ""
            : selectedDates.map { "\($0)" }.joined(separator: ", ")
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        let alertVC = UIAlertController(
            title: "날짜를 선택해 주세요!",
            message: nil,
            preferredStyle: .alert
        )
        alertVC.addAction(confirmAction)
        
        // 날짜 선택하지 않았다면 alert 실행
        if selectedDates.isEmpty {
            present(alertVC, animated: true)
        } else {
            guard let parentVC = parentVC else {
                print("Error: parentVC is nil")
                return
            }
            DispatchQueue.main.async {
                parentVC.addScheduleView.updateDateLabel(
                    isHidden: false,
                    date: translateSelectedDate
                )
            }
            dismiss(animated: true)
        }
    }
    
}

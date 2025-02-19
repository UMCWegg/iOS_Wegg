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
    private var formattedDates: [String] = [] // yyyy-MM-dd 형식의 날짜 배열
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

// MARK: - ScheduleCalendarViewDelegate

extension ScheduleCalendarViewController: ScheduleCalendarViewDelegate {
    
    /// 이전 달 버튼이 눌렸을 때 호출
    func didTapPrevMonthButton() {
        selectedDates.removeAll()
        calendarManager.goToPreviousMonth()
        setupDates(
            for: calendarManager.getYear(),
            month: calendarManager.getMonth()
        )
        DispatchQueue.main.async { [weak self] in
            guard let date = self?.calendarManager.getFormattedDate() else { return }
            self?.scheduleCalendarView.updateCalendar(date: date) // 연/월 라벨 업데이트
            self?.scheduleCalendarView.calendarCollectionView.reloadData()
        }
    }
    
    /// 다음 달 버튼이 눌렸을 때 호출
    func didTapNextMonthButton() {
        selectedDates.removeAll()
        calendarManager.goToNextMonth()
        setupDates(
            for: calendarManager.getYear(),
            month: calendarManager.getMonth()
        )
        DispatchQueue.main.async { [weak self] in
            guard let date = self?.calendarManager.getFormattedDate() else { return }
            self?.scheduleCalendarView.updateCalendar(date: date) // 연/월 라벨 업데이트
            self?.scheduleCalendarView.calendarCollectionView.reloadData()
        }
    }
    
    /// 취소 버튼이 눌렸을 때 호출
    func didTapCancelButton() {
        selectedDates.removeAll()
        dismiss(animated: true)
    }
    
    /// 확인 버튼이 눌렸을 때 호출
    func didTapConfirmButton() {
        // 선택된 날짜들을 콤마(", ")로 구분된 문자열로 변환
        let translateSelectedDate = selectedDates.isEmpty ? ""
        : Array(selectedDates).sorted().map { "\($0)" }.joined(separator: ", ")
        
        // 날짜를 선택하지 않았다면 경고(Alert) 메시지 표시
        if selectedDates.isEmpty {
            let confirmAction = UIAlertAction(title: "확인", style: .default)
            let alertVC = UIAlertController(
                title: "날짜를 선택해 주세요!",
                message: nil,
                preferredStyle: .alert
            )
            alertVC.addAction(confirmAction)
            present(alertVC, animated: true)
        } else {
            // 부모 뷰 컨트롤러 (`AddScheduleViewController`)에 선택한 날짜 전달
            guard let parentVC = parentVC else {
                print("Error: parentVC is nil")
                return
            }
            parentVC.selectedFormmatedDates = convertSelectedDatesToFormattedStrings()
            DispatchQueue.main.async {
                parentVC.addScheduleView.updateDateLabel(
                    isHidden: false, // 날짜가 선택되었으므로 라벨 보이게 설정
                    date: translateSelectedDate // 선택한 날짜 전달
                )
            }
            
            dismiss(animated: true) // 바텀 시트 닫기
        }
    }
    
    /// 선택된 날짜를 "yy-MM-dd" 형식으로 변환
    private func convertSelectedDatesToFormattedStrings() -> [String] {
        let year = calendarManager.getYear()
        let month = calendarManager.getMonth()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        
        for day in selectedDates {
            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = day
            
            if let date = Calendar.current.date(from: components) {
                formattedDates.append(formatter.string(from: date))
            }
        }
        
        return formattedDates.sorted() // 날짜 오름차순 정렬
    }
    
}

//
//  CalendarViewController.swift
//  iOS_Wegg
//

import UIKit

class CalendarViewController: UIViewController,
                              UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let apiManager = APIManager()
    let calendarView = CalendarView()
    private var days: [String] = []
    private let calendar = Calendar.current
    private var currentDate = Date()
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy년 M월"
    }
    
    private var monthlyData: [DayData] = [] // API 응답 데이터를 저장할 배열
    private var dateSummaries: [DateSummary] = [] // API 응답 데이터 요약 저장
    private var studyTimes: [String: String] = [:] // 공부 시간 데이터를 저장할 딕셔너리
    
    override func loadView() {
        view = calendarView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViews()
        setupButtonActions()
        fetchMonthlyData()
        // 초기 상태 설정
        calendarView.calendarCollectionView.isHidden = false
        calendarView.studyTimeView.isHidden = true
        fetchFollowInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupCollectionViews() {
        calendarView.calendarCollectionView.dataSource = self
        calendarView.calendarCollectionView.delegate = self
        calendarView.studyTimeView.studyTimeCollectionView.dataSource = self
        calendarView.studyTimeView.studyTimeCollectionView.delegate = self
    }
    
    private func fetchFollowInfo() {
        Task {
            do {
                let followLabelResponse: FollowLabelResponse = try await apiManager.request(
                    target: FollowAPI.getFollowInfo
                )
                
                await updateUI(with: followLabelResponse.result)
            } catch {
                print("Error fetching follow info: \(error)")
                // 에러 처리 로직 추가
            }
        }
    }
    
    private func updateUI(with result: FollowLabelResult) {
        calendarView.followerLabel.text = "\(result.followerCount)\n팔로워"
        calendarView.followingLabel.text = "\(result.followingCount)\n팔로잉"
        calendarView.profileLabel.text = result.accountId
        if let imageURLString = result.profileImage, let imageURL = URL(string: imageURLString) {
            // 프로필 이미지 로드 및 설정 (URLSession 또는 이미지 로딩 라이브러리 사용)
            // 예: SDWebImage 라이브러리 사용
            // calendarView.profileIcon.sd_setImage(with: imageURL, completed: nil)
        }
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
        // 토글 버튼의 초기 상태 설정 및 동작 정의
        calendarView.toggleButton.isOn = false
        calendarView.toggleButton.onToggleChanged = { [weak self] isOn in
            self?.calendarView.calendarCollectionView.isHidden = isOn
            self?.calendarView.studyTimeView.isHidden = !isOn
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc private func previousMonth() {
        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
        fetchMonthlyData()
    }
    
    @objc private func nextMonth() {
        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
        fetchMonthlyData()
    }
    
    // MARK: - API 연동: 월간 데이터 가져오기
    
    private func fetchMonthlyData() {
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        Task {
            do {
                let monthlyRenderResponse = try await apiManager.fetchMonthlyData(
                    year: year,
                    month: month
                )
                
                monthlyData = monthlyRenderResponse.result.monthlyData
                dateSummaries = monthlyRenderResponse.result.dateSummaries
                generateCalendar() // API 데이터 기반으로 캘린더 생성
            } catch {
                print("Error fetching monthly data: \(error)")
                // 에러 처리 로직 추가
            }
        }
    }
    
    private func generateCalendar() {
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        guard let startDate = calendar.date(from: components),
              let monthRange = calendar.range(
                of: .day,
                in: .month,
                for: startDate
              ) else { return }
        let firstWeekday = calendar.component(.weekday, from: startDate)
        let totalDays = monthRange.count
        let offset = (firstWeekday - 1 + 7) % 7 // 일요일부터 시작하는 경우를 위한 수정
        
        days.removeAll()
        
        // Add empty strings for the offset days.
        for _ in 0..<offset {
            days.append("")
        }
        
        // Add the days of the month.
        for day in 1...totalDays {
            days.append("\(day)")
        }
        
        calendarView.monthLabel.text = dateFormatter.string(from: currentDate)
        calendarView.calendarCollectionView.reloadData()
        
        // StudyTimeView 업데이트
        updateStudyTimeView()
    }
    
    private func updateStudyTimeView() {
        // 날짜를 "yyyy-MM-dd" 형식으로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        
        var studyTimesForMonth: [String: String] = [:]
        for day in days {
            guard let dayInt = Int(day) else { continue } // 숫자로 변환할 수 없는 경우 건너뜀
            let dateComponents = DateComponents(year: currentYear, month: currentMonth, day: dayInt)
            if let date = calendar.date(from: dateComponents) {
                let dateString = dateFormatter.string(from: date)
                
                // 해당 날짜에 대한 요약 정보를 찾음
                if let summary = dateSummaries.first(where: { $0.date == dateString }) {
                    studyTimesForMonth[day] = "\(summary.studyTime)"
                } else {
                    studyTimesForMonth[day] = "0" // 요약 정보가 없는 경우 기본값
                }
            }
        }
        calendarView.studyTimeView.updateStudyTimes(
            days: days,
            studyTimes: studyTimesForMonth,
            dateSummaries: dateSummaries
        )
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return days.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let day = days[indexPath.row]
        
        if collectionView == calendarView.calendarCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CalendarCell.identifier,
                for: indexPath) as? CalendarCell else { return UICollectionViewCell() }
            
            // Determine if the current cell represents today's date
            let isToday: Bool = {
                let currentComponents = calendar.dateComponents([.year, .month, .day], from: Date())
                let cellComponents = calendar.dateComponents([.year, .month], from: currentDate)
                
                guard let currentDay = currentComponents.day, let cellDay = Int(day) else {
                    return false
                }
                
                return currentComponents.year == cellComponents.year &&
                currentComponents.month == cellComponents.month &&
                cellDay == currentDay
            }()
            if day.isEmpty {
                // If the day is empty, configure the cell to display nothing.
                cell.configure(day: "")
            } else {
                var dailyData: DayData? = nil
                if let dayInt = Int(day), dayInt > 0 && dayInt <= monthlyData.count {
                    dailyData = monthlyData[dayInt - 1]
                }
                cell.configure(day: day, dailyData: dailyData, isToday: isToday)
            }
            
            
            return cell
        } else {
            // StudyTimeView에 대한 셀 구성
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StudyTimeCell.identifier,
                for: indexPath) as? StudyTimeCell else { return UICollectionViewCell() }
            // studyTimes 딕셔너리에서 해당 날짜의 studyTime을 가져옴
            let studyTime = studyTimes[day]
            
            // 날짜를 "yyyy-MM-dd" 형식으로 변환
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            // 날짜를 "yyyy-MM-dd" 형식으로 변환
            let currentYear = Calendar.current.component(.year, from: Date())
            let currentMonth = Calendar.current.component(.month, from: Date())
            var hasPlan: Bool? = nil
            var hasFailedPlan: Bool? = nil
            
            if let dayInt = Int(day) {
                let dateComponents = DateComponents(
                    year: currentYear,
                    month: currentMonth,
                    day: dayInt
                )
                
                if let date = Calendar.current.date(from: dateComponents) {
                    let dateString = dateFormatter.string(from: date)
                    if let summary = dateSummaries.first(where: {$0.date == dateString}){
                        hasPlan = true
                        hasFailedPlan = summary.hasFailedPlan
                    } else {
                        hasPlan = nil
                        hasFailedPlan = nil
                    }
                    
                }
            }
            
            cell.configure(
                day: day,
                studyTime: studyTime,
                hasPlan: hasPlan,
                hasFailedPlan: hasFailedPlan
            )
            
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = (collectionView.frame.width - 12) / 7
            return CGSize(width: width, height: width * 1.2)
        }
}

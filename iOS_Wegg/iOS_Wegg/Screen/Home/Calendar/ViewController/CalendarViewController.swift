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
        calendarView.nextButton.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)

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
                monthlyData = monthlyRenderResponse.result.monthlyData // API 응답 데이터를 저장
                dateSummaries = monthlyRenderResponse.result.dateSummaries // API 응답 데이터 요약 저장
                generateCalendar() // API 데이터 기반으로 캘린더 생성
                updateStudyTimeView() // StudyTimeView 업데이트
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

        let totalDays = monthRange.count

        days.removeAll()

        // 현재 달의 날짜 추가
        for dayIndex in 1...totalDays {
            days.append("\(dayIndex)")
        }

        calendarView.monthLabel.text = dateFormatter.string(from: currentDate)
        calendarView.calendarCollectionView.reloadData()
        calendarView.studyTimeView.studyTimeCollectionView.reloadData()
    }

    // StudyTimeView 업데이트 로직 추가
    private func updateStudyTimeView() {
        var studyTimeData: [String: String] = [:]
        for dayData in monthlyData {
            let date = dayData.date
            if let summary = dateSummaries.first(where: { $0.date == date }) {
                studyTimeData[date] = "\(summary.studyTime)분"
            } else {
                studyTimeData[date] = "0분"
            }
        }
       calendarView.studyTimeView.updateStudyTimes(days: days, studyTimes: studyTimeData)
    }


    // MARK: - UICollectionViewDataSource

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return days.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = days[indexPath.row]

        if collectionView == calendarView.calendarCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CalendarCell.identifier,
                for: indexPath) as? CalendarCell else { return UICollectionViewCell() }

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

            // day가 Int로 변환 가능한 경우에만 dailyData를 가져오도록 수정
            var dailyData: DayData? = nil
            if let dayInt = Int(day), dayInt > 0, dayInt <= monthlyData.count {
                dailyData = monthlyData[dayInt - 1]
            }
            
            cell.configure(day: day, dailyData: dailyData, isToday: isToday)
            return cell
        } else {
            // StudyTimeView에 대한 셀 구성
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StudyTimeCell.identifier,
                for: indexPath) as? StudyTimeCell else { return UICollectionViewCell() }
            
            // days 배열의 index에 해당하는 날짜를 가져옴
            let day = days[indexPath.row]
            
            // studyTimes 딕셔너리에서 해당 날짜의 studyTime을 가져옴
            let studyTime = studyTimes[day]
            
            // StudyTimeCell 구성
            cell.configure(day: day, studyTime: studyTime)
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

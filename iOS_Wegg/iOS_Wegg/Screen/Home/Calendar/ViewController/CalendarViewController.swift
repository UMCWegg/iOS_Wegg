//
//  CalendarViewController.swift
//  iOS_Wegg
//

import UIKit

class CalendarViewController: UIViewController {
    private let apiManager = APIManager()
    
    let calendarView = CalendarView()
    private var days: [String] = []
    private let calendar = Calendar.current
    private var currentDate = Date()
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy년 M월"
    }
    private var studyTimes: [String: String] = [:] // 공부 시간 데이터를 저장할 딕셔너리

    override func loadView() {
        view = calendarView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViews()
        setupButtonActions()
        generateCalendar()
        generateDummyStudyTimes()
        
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
                    target: FollowAPI.getFollowInfo)
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
            self, action: #selector(previousMonth),
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
        let offset = (firstWeekday - 1 + 7) % 7 // 일요일부터 시작하는 경우를 위한 수정
        
        days.removeAll()
        // 이전 달의 날짜 추가
        for _ in 0..<offset {
            days.append("")
        }
        // 현재 달의 날짜 추가
        for day in 1...totalDays {
            days.append("\(day)")
        }
        // 다음 달의 날짜 추가 (42개 셀을 채우기 위해)
        while days.count < 42 {
            days.append("")
        }
        
        calendarView.monthLabel.text = dateFormatter.string(from: currentDate)
        calendarView.calendarCollectionView.reloadData()
        calendarView.studyTimeView.studyTimeCollectionView.reloadData()
    }
    
    private func generateDummyStudyTimes() {
        let totalDays = calendar.range(of: .day, in: .month, for: currentDate)?.count ?? 30
        for _ in 1...10 { // 10개의 랜덤 날짜에 공부 시간 할당
            let randomDay = Int.random(in: 1...totalDays)
            let randomHours = Int.random(in: 0...3)
            let randomMinutes = Int.random(in: 0...59)
            studyTimes["\(randomDay)"] = "\(randomHours)H \(randomMinutes)M"
        }
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
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = days[indexPath.row]
        
        if collectionView == calendarView.calendarCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CalendarCell.identifier,
                for: indexPath
            ) as? CalendarCell else { return UICollectionViewCell() }
            
            let isToday: Bool = {
                let currentComponents = calendar.dateComponents([.year, .month, .day], from: Date())
                let cellComponents = calendar.dateComponents([.year, .month], from: currentDate)
                guard let currentDay = currentComponents.day,
                      let cellDay = Int(day) else {
                    return false
                }
                return currentComponents.year == cellComponents.year &&
                currentComponents.month == cellComponents.month &&
                cellDay == currentDay
            }()
            
            cell.configure(day: day, isToday: isToday)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StudyTimeCell.identifier,
                for: indexPath
            ) as? StudyTimeCell else { return UICollectionViewCell()
            }
            
            let studyTime = studyTimes[day]
            cell.configure(day: day, studyTime: studyTime)
            return cell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 12) / 7
        return CGSize(width: width, height: width * 1.2)
    }
}

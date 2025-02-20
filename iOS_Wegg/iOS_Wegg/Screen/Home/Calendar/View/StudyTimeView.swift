//
//  StudyTimeView.swift
//  iOS_Wegg
//
//  Created by KKM on 2/1/25.
//

import UIKit
import SnapKit
import Then

class StudyTimeView: UIView {

    // MARK: - UI Components

    let studyTimeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .clear
        collectionView.register(
            StudyTimeCell.self,
            forCellWithReuseIdentifier: StudyTimeCell.identifier
        )
        return collectionView
    }()

    private var studyTimes: [String: String] = [:]
    private var days: [String] = []
    private var dateSummaries: [String: DateSummary] = [:]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .primary
        addSubview(studyTimeCollectionView)
    }

    private func setupLayout() {
        studyTimeCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setupCollectionView() {
        studyTimeCollectionView.dataSource = self
        studyTimeCollectionView.delegate = self
    }

    func updateStudyTimes(
        days: [String],
        studyTimes: [String: String],
        dateSummaries: [DateSummary]
    ) {
        self.days = days
        self.studyTimes = studyTimes

        // dateSummaries를 사용하여 날짜별 DateSummary 정보 설정
        self.dateSummaries = Dictionary(uniqueKeysWithValues: dateSummaries.map {
            ($0.date, $0)
        })
        studyTimeCollectionView.reloadData()
    }
}

extension StudyTimeView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return days.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StudyTimeCell.identifier,
            for: indexPath) as? StudyTimeCell else {
            return UICollectionViewCell()
        }

        let day = days[indexPath.row]
        let studyTime = studyTimes[day]

        // 해당 날짜의 DateSummary 정보 가져오기
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

                if let summary = dateSummaries[dateString] {
                    hasPlan = true // DateSummary 정보가 있으면 계획이 있는 것으로 간주
                    hasFailedPlan = summary.hasFailedPlan
                } else {
                    hasPlan = nil // DateSummary 정보가 없으면 계획이 없는 것으로 간주
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

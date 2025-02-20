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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(
            StudyTimeCell.self,
            forCellWithReuseIdentifier: StudyTimeCell.identifier
        )
        return collectionView
    }()

    private var studyTimes: [String: String] = [:]
    private var days: [String] = []

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

     func updateStudyTimes(days: [String], studyTimes: [String: String]) {
            self.days = days
            self.studyTimes = studyTimes
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
            cell.configure(day: day, studyTime: studyTime)
            return cell
        }
}

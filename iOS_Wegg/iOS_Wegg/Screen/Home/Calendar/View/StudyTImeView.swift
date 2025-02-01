//
//  StudyTImeView.swift
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
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(StudyTimeCell.self, forCellWithReuseIdentifier: StudyTimeCell.identifier)
        return cv
    }()
    
    var studyTimes: [String] = [] {
        didSet {
            studyTimeCollectionView.reloadData()
        }
    }
    
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
            $0.edges.equalToSuperview().inset(16)
        }
    }
    
    private func setupCollectionView() {
        studyTimeCollectionView.dataSource = self
        studyTimeCollectionView.delegate = self
    }
}

extension StudyTimeView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return studyTimes.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StudyTimeCell.identifier,
            for: indexPath) as? StudyTimeCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: studyTimes[indexPath.row])
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 16
        let width = (collectionView.frame.width - totalSpacing) / 2
        return CGSize(width: width, height: 50)
    }
}

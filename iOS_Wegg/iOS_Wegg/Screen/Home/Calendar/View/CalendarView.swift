//
//  CalendarView.swift
//  iOS_Wegg
//

import UIKit
import SnapKit
import Then

class CalendarView: UIView {
    
    let headerView = HeaderView(isHomeMode: false)
    
    private let profileIcon = UIImageView().then {
        $0.image = UIImage(named: "profileIcon")
        $0.contentMode = .scaleAspectFit
    }
    
    private let profileLabel = UILabel().then {
        $0.text = "Me"
        $0.font = .notoSans(.medium, size: 14)
        $0.textColor = .secondary
    }
    
    private let followerLabel = UILabel().then {
        $0.text = "0\n팔로워"
        $0.font = .notoSans(.medium, size: 20)
        $0.textColor = .secondary
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private let followingLabel = UILabel().then {
        $0.text = "0\n팔로잉"
        $0.font = .notoSans(.medium, size: 20)
        $0.textColor = .secondary
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    let monthLabel = UILabel().then {
        $0.font = .notoSans(.medium, size: 20)
        $0.textColor = .secondary
        $0.textAlignment = .center
    }
    
    let toggleButton = ToggleButtonView()
    
    let weekdayStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
    let calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(
            CalendarCell.self,
            forCellWithReuseIdentifier: CalendarCell.identifier
        )
        return collectionView
    }()
    
    let studyTimeView = StudyTimeView()
    
    let previousButton = UIButton().then {
        $0.setImage(UIImage(named: "previous"), for: .normal)
        $0.tintColor = .secondary
    }
    
    let nextButton = UIButton().then {
        $0.setImage(UIImage(named: "next"), for: .normal)
        $0.tintColor = .secondary
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupWeekdays()
        setupLayout()
        setupToggleAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .primary
        addSubview(headerView)
        addSubview(profileIcon)
        addSubview(followerLabel)
        addSubview(followingLabel)
        addSubview(profileLabel)
        addSubview(monthLabel)
        addSubview(toggleButton)
        addSubview(weekdayStackView)
        addSubview(calendarCollectionView)
        addSubview(studyTimeView)
        addSubview(previousButton)
        addSubview(nextButton)
    }
    
    private func setupWeekdays() {
        ["일", "월", "화", "수", "목", "금", "토"].forEach { day in
            let label = UILabel()
            label.text = day
            label.textAlignment = .center
            label.font = .notoSans(.bold, size: 12)
            label.textColor = .secondary
            weekdayStackView.addArrangedSubview(label)
        }
    }
    
    private func setupLayout() {
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(60)
        }
        
        profileIcon.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(64)
        }
        
        profileLabel.snp.makeConstraints {
            $0.top.equalTo(profileIcon.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        followerLabel.snp.makeConstraints {
            $0.trailing.equalTo(profileIcon.snp.leading).offset(-40)
            $0.centerY.equalTo(profileIcon)
        }
        
        followingLabel.snp.makeConstraints {
            $0.leading.equalTo(profileIcon.snp.trailing).offset(40)
            $0.centerY.equalTo(profileIcon)
        }
        
        monthLabel.snp.makeConstraints {
            $0.top.equalTo(profileLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        previousButton.snp.makeConstraints {
            $0.centerY.equalTo(monthLabel)
            $0.trailing.equalTo(monthLabel.snp.leading).offset(-20)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerY.equalTo(monthLabel)
            $0.leading.equalTo(monthLabel.snp.trailing).offset(20)
        }
        
        toggleButton.snp.makeConstraints {
            $0.centerY.equalTo(monthLabel)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalTo(60)
            $0.height.equalTo(32)
        }
        
        weekdayStackView.snp.makeConstraints {
            $0.top.equalTo(monthLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(20)
        }
        
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(weekdayStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-10)
        }
        
        studyTimeView.snp.makeConstraints {
            $0.edges.equalTo(calendarCollectionView)
        }
    }
    
    private func setupToggleAction() {
        toggleButton.onToggleChanged = { [weak self] isOn in
            guard let self = self else { return }
            self.calendarCollectionView.isHidden = isOn
            self.studyTimeView.isHidden = !isOn
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
}

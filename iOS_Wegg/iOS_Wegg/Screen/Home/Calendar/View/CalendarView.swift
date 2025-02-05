//
//  CalendarView.swift
//  iOS_Wegg
//
//  Created by KKM on 2/1/25.
//

import UIKit
import SnapKit
import Then

class CalendarView: UIView {
    
    // MARK: - UI Components
    let headerView = HeaderView(isHomeMode: false)

    private let profileIcon = UIImageView().then {
        $0.image = UIImage(named: "profileIcon")
        $0.contentMode = .scaleAspectFit
    }
    
    private let profileLabel = UILabel().then {
        $0.text = "Me"
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = UIColor.label
    }
    
    private let followerLabel = UILabel().then {
        $0.text = "0\n팔로워"
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textColor = UIColor.label
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private let followingLabel = UILabel().then {
        $0.text = "0\n팔로잉"
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textColor = UIColor.label
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    let monthLabel = UILabel().then {
        $0.text = "2025년 1월"
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textColor = UIColor.label
        $0.textAlignment = .center
    }
    
    let previousButton = UIButton().then {
        $0.setTitle("<", for: .normal)
        $0.setTitleColor(UIColor.label, for: .normal)
    }
    
    let nextButton = UIButton().then {
        $0.setTitle(">", for: .normal)
        $0.setTitleColor(UIColor.label, for: .normal)
    }
    
    let toggleButton = ToggleButtonView()
    
    let containerView = UIView() // 두 개의 컬렉션 뷰를 담는 컨테이너 뷰 추가

    let calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 2 // 셀 간 간격을 최소화 (기존 8 → 2)
        layout.minimumLineSpacing = 8
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.identifier)
        return cv
    }()
    
    let studyTimeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(StudyTimeCell.self, forCellWithReuseIdentifier: StudyTimeCell.identifier)
        cv.isHidden = true // 기본적으로 숨김
        return cv
    }()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setupToggleAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        backgroundColor = .primary
        addSubview(headerView)
        addSubview(profileIcon)
        addSubview(followerLabel)
        addSubview(followingLabel)
        addSubview(profileLabel)
        addSubview(monthLabel)
        addSubview(previousButton)
        addSubview(nextButton)
        addSubview(toggleButton)
        addSubview(containerView) // 컨테이너 뷰 추가
        containerView.addSubview(calendarCollectionView) // 컨테이너에 추가
        containerView.addSubview(studyTimeCollectionView) // 컨테이너에 추가
    }
    
    private func setupLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        profileIcon.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(64)
        }
        
        followerLabel.snp.makeConstraints {
            $0.trailing.equalTo(profileIcon.snp.leading).offset(-40)
            $0.centerY.equalTo(profileIcon)
        }
        
        followingLabel.snp.makeConstraints {
            $0.leading.equalTo(profileIcon.snp.trailing).offset(40)
            $0.centerY.equalTo(profileIcon)
        }
        
        profileLabel.snp.makeConstraints {
            $0.top.equalTo(profileIcon.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        monthLabel.snp.makeConstraints {
            $0.top.equalTo(profileLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        previousButton.snp.makeConstraints {
            $0.centerY.equalTo(monthLabel)
            $0.trailing.equalTo(monthLabel.snp.leading).offset(-10)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerY.equalTo(monthLabel)
            $0.leading.equalTo(monthLabel.snp.trailing).offset(10)
        }
        
        toggleButton.snp.makeConstraints {
            $0.centerY.equalTo(monthLabel)
            $0.trailing.equalToSuperview().offset(-21)
            $0.width.equalTo(60)
            $0.height.equalTo(32)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(monthLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview().inset(10)
        }

        calendarCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        studyTimeCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupToggleAction() {
        toggleButton.onToggleChanged = { [weak self] isOn in
            self?.calendarCollectionView.isHidden = isOn
            self?.studyTimeCollectionView.isHidden = !isOn
        }
    }
}

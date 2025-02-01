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
    let headerView = HeaderView()

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
        $0.text = "2025년 1월"
        $0.font = .notoSans(.medium, size: 20)
        $0.textColor = .secondary
        $0.textAlignment = .center
    }
    
    let previousButton = UIButton().then {
        $0.setTitle("<", for: .normal)
        $0.setTitleColor(.secondary, for: .normal)
    }
    
    let nextButton = UIButton().then {
        $0.setTitle(">", for: .normal)
        $0.setTitleColor(.secondary, for: .normal)
    }
    
    let toggleButton = ToggleButtonView()

    // 기존 달력 컬렉션 뷰 (월간 달력)
    let calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.identifier)
        return cv
    }()

    // 새로운 공부 시간 컬렉션 뷰 (공부 시간만 표시)
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

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setupToggleAction() // ✅ 토글 버튼 액션 추가
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

        addSubview(calendarCollectionView)
        addSubview(studyTimeCollectionView)

        studyTimeCollectionView.isHidden = true // ✅ 초기에는 월간 달력만 보이도록 설정
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
         
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(monthLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
        }

        studyTimeCollectionView.snp.makeConstraints {
            $0.top.equalTo(monthLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }

    // ✅ 토글 버튼을 눌렀을 때 collectionView 변경
    private func setupToggleAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleState))
        toggleButton.addGestureRecognizer(tapGesture)
    }

    // ✅ 토글 버튼 상태 변경 시 호출
    @objc private func toggleState() {
        let isOn = toggleButton.isOn // 토글 상태 확인
        
        calendarCollectionView.isHidden = isOn
        studyTimeCollectionView.isHidden = !isOn
    }
}

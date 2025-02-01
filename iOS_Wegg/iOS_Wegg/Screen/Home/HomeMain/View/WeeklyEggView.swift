//
//  WeeklyEggView.swift
//  iOS_Wegg
//
//  Created by KKM on 1/29/25.
//

import UIKit
import SnapKit
import Then

class WeeklyEggView: UIView {

    // MARK: - UI Components
    private let calendarStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
    }

    private var dayEggs: [UIImageView] = []
    private var dayLabels: [UILabel] = []

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setupInitialState()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupUI() {
        addSubview(calendarStackView)
        setupCalendarStackView()
    }

    private func setupLayout() {
        calendarStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        setupCalendarDayConstraints()
    }

    private func setupCalendarStackView() {
        let days = ["월", "화", "수", "목", "금", "토", "일"]
        for day in days {
            let eggImageView = UIImageView().then {
                $0.image = UIImage(named: "emptyEgg")
                $0.contentMode = .scaleAspectFit
            }
            dayEggs.append(eggImageView)

            let dayLabel = UILabel().then {
                $0.text = day
                $0.textColor = .secondary
                $0.textAlignment = .center
                $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            }
            dayLabels.append(dayLabel)

            let dayStack = UIStackView().then {
                $0.axis = .vertical
                $0.alignment = .center
                $0.spacing = 4
                $0.addArrangedSubview(eggImageView)
                $0.addArrangedSubview(dayLabel)
            }

            calendarStackView.addArrangedSubview(dayStack)
        }
    }

    private func setupCalendarDayConstraints() {
        for (index, eggImageView) in dayEggs.enumerated() {
            eggImageView.snp.makeConstraints {
                $0.width.height.equalTo(50)
            }

            dayLabels[index].snp.makeConstraints {
                $0.width.equalTo(eggImageView)
                $0.top.equalTo(eggImageView.snp.bottom).offset(4)
            }
        }
    }

    // MARK: - Public Methods
    func updateEggImage(for day: Int, with imageName: String) {
        guard dayEggs.indices.contains(day) else {
            print("Invalid day index: \(day). dayEggs count: \(dayEggs.count)")
            return
        }
        dayEggs[day].image = UIImage(named: imageName)
    }
    
    func setupInitialState() {
        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: Date()) - 2

        if today >= 0 && today < 7 {
            updateEggImage(for: today, with: "fillEgg")
        }
    }
    
    // MARK: - Actions
    @objc private func locationAuthTapped() {
        print("장소 인증 터치")
    }

    @objc private func photoAuthTapped() {
        print("사진 인증 터치")
    }
    
    @objc private func addTodoButtonTapped() {
        print("TO DO LIST 추가 버튼 터치")
    }
}

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
    private let calendarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()

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
        calendarStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        setupCalendarDayConstraints()
    }

    private func setupCalendarStackView() {
        let days = ["월", "화", "수", "목", "금", "토", "일"]
        for day in days {
            let dayStack = UIStackView()
            dayStack.axis = .vertical
            dayStack.alignment = .center
            dayStack.spacing = 4

            let eggImageView = UIImageView(image: UIImage(named: "emptyEgg"))
            eggImageView.contentMode = .scaleAspectFit
            dayEggs.append(eggImageView)

            let dayLabel = UILabel()
            dayLabel.text = day
            dayLabel.textColor = .secondary
            dayLabel.textAlignment = .center
            dayLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            dayLabels.append(dayLabel)

            dayStack.addArrangedSubview(eggImageView)
            dayStack.addArrangedSubview(dayLabel)

            calendarStackView.addArrangedSubview(dayStack)
        }
    }

    private func setupCalendarDayConstraints() {
        for (index, eggImageView) in dayEggs.enumerated() {
            eggImageView.snp.makeConstraints { make in
                make.width.height.equalTo(50)
            }

            dayLabels[index].snp.makeConstraints { make in
                make.width.equalTo(eggImageView)
                make.top.equalTo(eggImageView.snp.bottom).offset(4)
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

//
//  TimerView.swift
//  iOS_Wegg
//
//  Created by KKM on 1/29/25.
//

import UIKit
import SnapKit
import Then

final class TimerView: UIView {
    // MARK: - Properties
    private var timer: Timer?
    private var totalSeconds: Int = 0
    private var isRunning = false
    
    // MARK: - UI Components
    private lazy var titleLabel = UILabel().then {
        $0.text = "총 공부 시간"
        $0.font = UIFont(name: "NotoSansKR-Regular", size: 13)
        $0.textColor = UIColor(
            red: 124 / 255,
            green: 80 / 255,
            blue: 45 / 255,
            alpha: 1.0
        ) // #7C502D
    }
    
    private lazy var timeLabel = UILabel().then {
        $0.text = "00:00:00"
        $0.font = UIFont(name: "NotoSansKR-Regular", size: 24)
        $0.textColor = UIColor(
            red: 124 / 255,
            green: 80 / 255,
            blue: 45 / 255,
            alpha: 1.0
        ) // #7C502D
        $0.textAlignment = .center
    }
    
    private lazy var playButton = UIButton().then {
        $0.setImage(UIImage(named: "timerStart"), for: .normal)
        $0.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }
    
    private lazy var timeView = UIView().then {
        $0.backgroundColor = .clear
    }

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        self.do {
            $0.backgroundColor = UIColor(
                red: 255 / 255,
                green: 253 / 255,
                blue: 249 / 255,
                alpha: 1.0
            )
            $0.layer.cornerRadius = 24
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(
                red: 124 / 255,
                green: 80 / 255,
                blue: 45 / 255,
                alpha: 1.0
            ).cgColor // #7C502D
        }
        
        addSubview(titleLabel)
        addSubview(timeView)
        
        timeView.addSubview(timeLabel)
        timeView.addSubview(playButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
        }

        timeView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }

        timeLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }

        playButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(timeLabel.snp.trailing).offset(14)
            $0.size.equalTo(23)
            $0.trailing.equalToSuperview() // timeView 크기 자동 조정
        }
    }

    // MARK: - Actions
    @objc private func playButtonTapped() {
        isRunning ? stopTimer() : startTimer()
    }
    
    // MARK: - Timer Methods
    private func startTimer() {
        isRunning = true
        playButton.setImage(UIImage(named: "timerStop"), for: .normal)

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.totalSeconds += 1
            self.updateTimeLabel()
        }
    }
    
    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        playButton.setImage(UIImage(named: "timerStart"), for: .normal)
    }
    
    private func updateTimeLabel() {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    // MARK: - Public Methods
    func reset() {
        stopTimer()
        totalSeconds = 0
        updateTimeLabel()
    }
    
    func getCurrentTime() -> Int {
        return totalSeconds
    }
}

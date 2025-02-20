//
//  WeeklyEggView.swift
//  iOS_Wegg
//
//  Created by KKM on 1/29/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

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
    private var circleViews: [UIView] = []
    
    private let daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"]
    
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
        for day in daysOfWeek {
            let dayStack = UIStackView()
            dayStack.axis = .vertical
            dayStack.alignment = .center
            dayStack.spacing = 12
            
            let eggImageView = UIImageView() // 초기 이미지 설정 제거
            eggImageView.contentMode = .scaleAspectFit
            dayEggs.append(eggImageView)
            
            let circleView = UIView().then {
                $0.backgroundColor = .clear
                $0.layer.borderWidth = 1
                $0.layer.borderColor = UIColor.secondary.cgColor
                $0.layer.cornerRadius = 12
                $0.isHidden = true
            }
            circleViews.append(circleView)
            
            let dayLabel = UILabel().then {
                $0.text = day
                $0.textColor = .secondary
                $0.textAlignment = .center
                $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            }
            dayLabels.append(dayLabel)
            
            let labelContainer = UIView()
            labelContainer.addSubview(circleView)
            labelContainer.addSubview(dayLabel)
            
            circleView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(24)
            }
            
            dayLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            
            dayStack.addArrangedSubview(eggImageView)
            dayStack.addArrangedSubview(labelContainer)
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
                make.top.equalTo(eggImageView.snp.bottom).offset(8)
            }
        }
    }
    
    // MARK: - Public Methods
    
    func updateEggImage(for day: Int, with imageSource: String?) {
        guard dayEggs.indices.contains(day) else {
            print("Invalid day index: \(day). dayEggs count: \(dayEggs.count)")
            return
        }
        
        if let imageSource = imageSource,
           !imageSource.isEmpty,
           imageSource.hasPrefix("http"),
           let url = URL(string: imageSource) {
            print("🖼️ Kingfisher로 이미지 로드 후 emptyEgg 배경 적용: \(imageSource)")
            // Kingfisher로 로드한 후 emptyEgg 배경을 입히는 처리
            dayEggs[day].kf.setImage(with: url, completionHandler: { result in
                switch result {
                case .success(let value):
                    let serverImage = value.image
                    if let finalImage = self.applyEggMask(to: serverImage) {
                        DispatchQueue.main.async { // UI 업데이트는 메인 스레드에서
                            self.dayEggs[day].image = finalImage
                        }
                    }
                case .failure(let error):
                    print("❌ Kingfisher 이미지 로드 실패: \(error)")
                    DispatchQueue.main.async { // UI 업데이트는 메인 스레드에서
                        self.dayEggs[day].image = UIImage(named: "emptyEgg") // 실패 시 기본값
                    }
                }
            })
        } else {
            // Assets에 있는 이미지는 직접 UIImage(named:) 사용
            print("🥚 Assets 이미지 사용: \(imageSource ?? "emptyEgg")")
            dayEggs[day].image = UIImage(named: imageSource ?? "emptyEgg")
        }
    }
    
    private func applyEggMask(to image: UIImage) -> UIImage? {
        guard let eggMask = UIImage(named: "emptyEgg") else {
            print("⚠️ emptyEgg 이미지 로드 실패")
            return nil
        }
        
        let renderer = UIGraphicsImageRenderer(size: eggMask.size)
        return renderer.image { context in
            let cgContext = context.cgContext
            // 1️⃣ 배경을 yellowWhite로 채우기
            cgContext.setFillColor(UIColor.yellowWhite.cgColor) // `.yellowWhite` 배경 적용
            cgContext.fill(CGRect(origin: .zero, size: eggMask.size))
            // 2️⃣ 이미지를 emptyEgg 크기에 맞게 그림
            let imageRect = CGRect(origin: .zero, size: eggMask.size)
            image.draw(in: imageRect)
            // 3️⃣ emptyEgg 이미지(테두리) 위에 덮어서 겹치는 문제 해결
            eggMask.draw(in: imageRect, blendMode: .normal, alpha: 1.0)
        }
    }
    
    func setupInitialState() {
        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: Date()) - 2
        if today >= 0 && today < 7 {
            circleViews[today].isHidden = false
            dayLabels[today].textColor = .secondary
        }
    }
    
    // MARK: - Additional Public Methods
    
    /// ✅ 주간 데이터 업데이트 (API 호출 후)
    func updateWeeklyData(weeklyData: [WeeklyData]) {
        guard weeklyData.count == 7 else {
            print("⚠️ Error: 주간 데이터는 7개여야 합니다.")
            return
        }
        
        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: Date()) - 2
        
        for (index, data) in weeklyData.enumerated() {
            print("날짜 \(index) - \(data)")
            if let post = data.post {
                print("날짜 \(index) post 있음")
                updateEggImage(for: index, with: post.imageUrl)
            } else if let plan = data.plan {
                print("날짜 \(index) plan 있음")
                if index < today { // 과거
                    print("날짜 \(index) 과거 -> brokenEgg 표시")
                    updateEggImage(for: index, with: "brokenEgg")
                } else { // 미래
                    print("날짜 \(index) 미래 -> fillEgg 표시")
                    updateEggImage(for: index, with: "fillEgg")
                }
            } else {
                print("날짜 \(index) plan 없음")
                updateEggImage(for: index, with: "emptyEgg")
            }
        }
    }
}

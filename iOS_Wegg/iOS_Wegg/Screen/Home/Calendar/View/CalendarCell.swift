//
//  CalendarCell.swift
//  iOS_Wegg
//

import UIKit
import SnapKit
import Then
import Kingfisher

class CalendarCell: UICollectionViewCell {
    static let identifier = "CalendarCell"

    // MARK: - UI Components
    private let eggImageView = UIImageView().then {
        $0.image = UIImage(named: "emptyEgg")
        $0.contentMode = .scaleAspectFit
    }

    let dateLabel = UILabel().then {
        $0.font = .notoSans(.regular, size: 14)
        $0.textAlignment = .center
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.8
    }

    private let circleView = UIView().then {
        $0.layer.borderWidth = 1.5
        $0.layer.cornerRadius = 12
        $0.isHidden = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(eggImageView)
        contentView.addSubview(circleView)
        contentView.addSubview(dateLabel)
    }

    private func setupLayout() {
        eggImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        circleView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }

        dateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }

    func configure(day: String, dailyData: DayData? = nil, isToday: Bool = false) {
        dateLabel.text = day
        if day.isEmpty {
            eggImageView.isHidden = true
            circleView.isHidden = true
            dateLabel.text = ""
            return
        }

        if isToday {
            circleView.backgroundColor = .clear
            circleView.layer.borderColor = UIColor.secondary.cgColor
            circleView.isHidden = false
            dateLabel.textColor = .secondary
        } else {
            circleView.backgroundColor = .clear
            circleView.layer.borderColor = UIColor.secondary.cgColor
            circleView.isHidden = true
            dateLabel.textColor = .black
        }

        // API 데이터에 따른 추가 설정
        if let dailyData = dailyData {
            eggImageView.isHidden = false // dailyData가 있는 경우 보이도록 설정
            if let post = dailyData.post {
                // post가 있는 경우, imageUrl을 사용하여 이미지 로드
                updateEggImage(with: post.imageUrl)
            } else if dailyData.plan != nil {
                // plan이 있는 경우, plan에 따른 이미지 설정 (예: "fillEgg" 또는 "brokenEgg")
                eggImageView.image = UIImage(named: "fillEgg") // 예시 이미지
            } else {
                // plan과 post가 모두 없는 경우 기본 이미지 설정
                eggImageView.image = UIImage(named: "emptyEgg")
            }
        } else {
            // dailyData가 없는 경우 기본 이미지 설정
            eggImageView.image = UIImage(named: "emptyEgg")
            eggImageView.isHidden = true // dailyData가 없는 경우 숨김
        }
    }

    private func updateEggImage(with imageSource: String?) {
        guard let imageSource = imageSource,
              !imageSource.isEmpty,
              imageSource.hasPrefix("http"),
              let url = URL(string: imageSource) else {
            // 유효하지 않은 이미지 URL 처리
            eggImageView.image = UIImage(named: "emptyEgg")
            return
        }

        print("🖼️ Kingfisher로 이미지 로드 후 emptyEgg 배경 적용: \(imageSource)")
        // Kingfisher로 로드한 후 emptyEgg 배경을 입히는 처리
        eggImageView.kf.setImage(with: url, completionHandler: { result in
            switch result {
            case .success(let value):
                let serverImage = value.image
                if let finalImage = self.applyEggMask(to: serverImage) {
                    DispatchQueue.main.async { // UI 업데이트는 메인 스레드에서
                        self.eggImageView.image = finalImage
                    }
                }
            case .failure(let error):
                print("❌ Kingfisher 이미지 로드 실패: \(error)")
                DispatchQueue.main.async { // UI 업데이트는 메인 스레드에서
                    self.eggImageView.image = UIImage(named: "emptyEgg") // 실패 시 기본값
                }
            }
        })
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
}

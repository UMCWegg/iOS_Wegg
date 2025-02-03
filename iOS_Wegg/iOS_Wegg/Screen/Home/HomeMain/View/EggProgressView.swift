//
//  EggProgressView.swift
//  iOS_Wegg
//
//  Created by KKM on 1/30/25.
//

import UIKit
import SnapKit
import Then

class EggProgressView: UIView {
    
    private let progressLayer = CAShapeLayer().then {
        $0.strokeColor = UIColor.systemYellow.cgColor
        $0.fillColor = UIColor.clear.cgColor
        $0.lineWidth = 6
        $0.strokeStart = 0  // 시작점을 명확히 지정
        $0.strokeEnd = 0
        $0.lineCap = .round
    }
    
    private let backgroundLayer = CAShapeLayer().then {
        $0.strokeColor = UIColor.lightGray.cgColor
        $0.fillColor = UIColor.clear.cgColor
        $0.lineWidth = 6
    }
    
    private let percentageLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.textColor = UIColor.systemYellow
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateEggPath()
    }

    private func setupView() {
        self.backgroundColor = .clear
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(progressLayer)
        addSubview(percentageLabel)
        
        percentageLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func setProgress(_ progress: CGFloat, animated: Bool = true) {
        let clampedProgress = max(0, min(progress, 1)) // 0~1 범위 제한
        
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = 0.5
            animation.fromValue = progressLayer.strokeEnd
            animation.toValue = clampedProgress
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            progressLayer.add(animation, forKey: "progressAnimation")
        }
        
        progressLayer.strokeEnd = clampedProgress
        percentageLabel.text = "\(Int(clampedProgress * 100))%"
    }
    
    private func updateEggPath() {
        let eggPath = UIBezierPath()
        drawEggShape(path: eggPath, in: bounds)
        
        backgroundLayer.path = eggPath.cgPath
        progressLayer.path = eggPath.cgPath
    }
    
    private func drawEggShape(path: UIBezierPath, in rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        // 시작점을 **하단 중앙**으로 설정하여 시계 방향 진행
        path.move(to: CGPoint(x: width * 0.5, y: height))
        
        // 왼쪽 곡선
        path.addCurve(to: CGPoint(x: 0, y: height * 0.6),
                      controlPoint1: CGPoint(x: width * 0.3, y: height),
                      controlPoint2: CGPoint(x: 0, y: height * 0.85))
        
        // 상단 곡선 (왼쪽에서 위쪽으로 올라감)
        path.addCurve(to: CGPoint(x: width * 0.5, y: 0),
                      controlPoint1: CGPoint(x: 0, y: height * 0.3),
                      controlPoint2: CGPoint(x: width * 0.3, y: 0))
        
        // 오른쪽 곡선 (위쪽에서 아래쪽으로 내려감)
        path.addCurve(to: CGPoint(x: width, y: height * 0.6),
                      controlPoint1: CGPoint(x: width * 0.7, y: 0),
                      controlPoint2: CGPoint(x: width, y: height * 0.3))
        
        // 다시 하단 중앙으로 연결
        path.addCurve(to: CGPoint(x: width * 0.5, y: height),
                      controlPoint1: CGPoint(x: width, y: height * 0.85),
                      controlPoint2: CGPoint(x: width * 0.7, y: height))
        
        path.close() // 경로 닫기
    }
}

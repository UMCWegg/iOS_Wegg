//
//  ToggleButtonView.swift
//  iOS_Wegg
//
//  Created by KKM on 2/1/25.
//

import UIKit
import SnapKit
import Then

class ToggleButtonView: UIView {
    
    // MARK: - Properties
    var isOn: Bool = false {
        didSet {
            updateTogglePosition(animated: true)
            updateToggleText()
            onToggleChanged?(isOn) /// 토글 변경 시 호출
        }
    }
    
    var onToggleChanged: ((Bool) -> Void)? /// 토글 상태 변경 시 호출되는 클로저
    
    // MARK: - UI Components
    private let backgroundView = UIView().then {
        $0.backgroundColor = .yellowWhite
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.secondary.cgColor
        $0.isUserInteractionEnabled = true
    }
    
    private let toggleView = UIView().then {
        $0.backgroundColor = .secondary
        $0.layer.cornerRadius = 15
    }
    
    private let toggleLabel = UILabel().then {
        $0.font = .notoSans(.bold, size: 12)
        $0.textColor = .primary
        $0.textAlignment = .center
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGesture()
        updateToggleText() // 초기 텍스트 설정
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        addSubview(backgroundView)
        backgroundView.addSubview(toggleView)
        toggleView.addSubview(toggleLabel)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        toggleView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.centerY.equalToSuperview()
            make.leading.equalTo(backgroundView.snp.leading).offset(1) // 초기 위치
        }
        
        toggleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleState))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func toggleState() {
        isOn.toggle()
    }
    
    private func updateTogglePosition(animated: Bool) {
        let newLeadingOffset = isOn ? (backgroundView.frame.width - toggleView.frame.width - 1) : 1

        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.toggleView.snp.updateConstraints { make in
                    make.leading.equalTo(self.backgroundView.snp.leading).offset(newLeadingOffset)
                }
                self.layoutIfNeeded()
            })
        } else {
            self.toggleView.snp.updateConstraints { make in
                make.leading.equalTo(self.backgroundView.snp.leading).offset(newLeadingOffset)
            }
            self.layoutIfNeeded()
        }
    }
    
    private func updateToggleText() {
        toggleLabel.text = isOn ? "T" : "P"
    }
}

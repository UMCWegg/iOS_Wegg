//
//  HeaderView.swift
//  iOS_Wegg
//
//  Created by KKM on 1/29/25.
//

import UIKit
import SnapKit
import Then

class HeaderView: UIView {
    
    // MARK: - UI Components
    private let weggLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "weggLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let point: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "point"), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()

    let calendar: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "calendar"), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()

    let bell: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "bell"), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        addSubview(weggLogo)
        addSubview(point)
        addSubview(calendar)
        addSubview(bell)
    }
    
    private func setupLayout() {
        weggLogo.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.width.equalTo(78)
            make.height.equalTo(30)
        }

        point.snp.makeConstraints { make in
            make.trailing.equalTo(calendar.snp.leading).offset(-20)
            make.centerY.equalTo(weggLogo)
            make.width.height.equalTo(20)
        }
        
        bell.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(weggLogo)
            make.width.height.equalTo(20)
        }

        calendar.snp.makeConstraints { make in
            make.trailing.equalTo(bell.snp.leading).offset(-20)
            make.centerY.equalTo(weggLogo)
            make.width.height.equalTo(20)
        }
    }
    
    private func setupActions() {
        point.addTarget(self, action: #selector(pointTapped), for: .touchUpInside)
        calendar.addTarget(self, action: #selector(calendarTapped), for: .touchUpInside)
        bell.addTarget(self, action: #selector(bellTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func pointTapped() {
        print("포인트 버튼 터치 ✅")
    }

    @objc private func calendarTapped() {
        print("캘린더 버튼 터치 ✅")
    }
    
    @objc private func bellTapped() {
        print("알림 버튼 터치 ✅")
    }
}

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
    private let weggLogo = UIImageView().then {
        $0.image = UIImage(named: "weggLogo")
        $0.contentMode = .scaleAspectFit
    }

    let point = UIButton().then {
        $0.setImage(UIImage(named: "point"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }

    let calendar = UIButton().then {
        $0.setImage(UIImage(named: "calendar"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }

    let bell = UIButton().then {
        $0.setImage(UIImage(named: "bell"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }

    weak var viewController: UIViewController?

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
        let notiVC = NotiViewController()
        notiVC.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(notiVC, animated: true)
    }
}

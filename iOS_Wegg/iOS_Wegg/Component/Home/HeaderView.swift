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

    let calendarOrHomeButton = UIButton().then {
        $0.contentMode = .scaleAspectFit
    }

    let bell = UIButton().then {
        $0.setImage(UIImage(named: "bell"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }

    weak var viewController: UIViewController?
    private var isHomeMode: Bool = false

    // MARK: - Initializers
    init(isHomeMode: Bool = false) {
        self.isHomeMode = isHomeMode
        super.init(frame: .zero)
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
        addSubview(calendarOrHomeButton)
        addSubview(bell)
        updateHeaderMode(isHomeMode: isHomeMode)
    }
    
    private func setupLayout() {
        weggLogo.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(16)
            $0.width.equalTo(78)
            $0.height.equalTo(30)
        }

        point.snp.makeConstraints {
            $0.trailing.equalTo(calendarOrHomeButton.snp.leading).offset(-20)
            $0.centerY.equalTo(weggLogo)
            $0.width.height.equalTo(20)
        }
        
        bell.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(weggLogo)
            $0.width.height.equalTo(20)
        }

        calendarOrHomeButton.snp.makeConstraints {
            $0.trailing.equalTo(bell.snp.leading).offset(-20)
            $0.centerY.equalTo(weggLogo)
            $0.width.height.equalTo(20)
        }
    }
    
    private func setupActions() {
        point.addTarget(self, action: #selector(pointTapped), for: .touchUpInside)
        calendarOrHomeButton.addTarget(
            self,
            action: #selector(calendarOrHomeButtonTapped),
            for: .touchUpInside
        )
        bell.addTarget(self, action: #selector(bellTapped), for: .touchUpInside)
    }
    
    // MARK: - Public Method
    func updateHeaderMode(isHomeMode: Bool) {
        self.isHomeMode = isHomeMode
        let buttonImage = isHomeMode ? "calendar" : "home"
        calendarOrHomeButton.setImage(UIImage(named: buttonImage), for: .normal)
    }
    
    // MARK: - Actions
    @objc private func pointTapped() {
        print("포인트 버튼 터치 ✅")
    }

    @objc private func calendarOrHomeButtonTapped() {
        guard let viewController = viewController else { return }

        if isHomeMode {
            print("캘린더 버튼 터치 ✅")
            let calendarVC = CalendarViewController()
            viewController.navigationController?.pushViewController(calendarVC, animated: false)
        } else {
            print("홈 버튼 터치 ✅")
            viewController.navigationController?.popViewController(animated: false)
        }
    }
    
    @objc private func bellTapped() {
        print("알림 버튼 터치 ✅")
        let notiVC = NotiViewController()
        notiVC.hidesBottomBarWhenPushed = true
        
        if let navigationController = viewController?.navigationController {
            /// 네비게이션 컨트롤러가 있는 경우
            navigationController.pushViewController(notiVC, animated: true)
        } else if let presentingViewController = viewController?.presentingViewController {
            /// 현재 뷰 컨트롤러가 모달로 표시된 경우
            viewController?.dismiss(animated: false) {
                presentingViewController.present(notiVC, animated: true, completion: nil)
            }
        } else {
            /// 그 외의 경우 (예: 루트 뷰 컨트롤러인 경우)
            viewController?.present(notiVC, animated: true, completion: nil)
        }
    }
}

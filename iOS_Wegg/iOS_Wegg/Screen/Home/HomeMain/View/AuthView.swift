//
//  AuthView.swift
//  iOS_Wegg
//
//  Created by KKM on 1/29/25.
//

import UIKit
import SnapKit
import Then

final class AuthView: UIView {

    // MARK: - UI Components
    private let weggLocation = UIImageView().then {
        $0.image = UIImage(named: "location")
        $0.contentMode = .scaleAspectFit
    }
    
    private let locationLabel = UILabel().then {
        $0.text = "스타벅스 미아점"
        $0.font = .systemFont(ofSize: 12, weight: .bold)
        $0.textColor = .black
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "곧 공부할 시간이에요!"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .black
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "🚨서둘러 인증을 진행해주세요"
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = .gray
    }
    
    private let authStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 16
    }
    
    let locationAuthButton = AuthView.createAuthButton(imageName: "locCert", title: "장소 인증하기")
    let photoAuthButton = AuthView.createAuthButton(imageName: "photoCert", title: "사진 인증하기")

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
        authStackView.addArrangedSubview(locationAuthButton)
        authStackView.addArrangedSubview(photoAuthButton)
        
        [weggLocation, locationLabel, titleLabel, subtitleLabel, authStackView].forEach {
            addSubview($0)
        }
    }

    private func setupLayout() {
        weggLocation.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(16)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.leading.equalTo(weggLocation.snp.trailing).offset(4)
            make.centerY.equalTo(weggLocation)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(weggLocation.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        authStackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo((UIScreen.main.bounds.width - (16 * 3)) / 2)
            make.bottom.equalToSuperview().offset(-8)
        }
    }

    private func setupActions() {
        locationAuthButton.addTarget(
            self,
            action: #selector(locationAuthTapped),
            for: .touchUpInside
        )

        photoAuthButton.addTarget(
            self,
            action: #selector(photoAuthTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func locationAuthTapped() {
        print("장소 인증 터치 ✅")
    }

    @objc private func photoAuthTapped() {
        print("사진 인증 터치 ✅")
    }

    // MARK: - Helper Method
    static func createAuthButton(imageName: String, title: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor(
            red: 255 / 255,
            green: 253 / 255,
            blue: 249 / 255,
            alpha: 1.0
        )
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(
            red: 162 / 255,
            green: 131 / 255,
            blue: 106 / 255,
            alpha: 1.0
        ).cgColor
        button.isUserInteractionEnabled = true // ✅ 버튼 터치 활성화

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.isUserInteractionEnabled = false // ✅ 내부 요소 터치 이벤트 버튼으로 전달

        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }

        let label = UILabel()
        label.text = title
        label.textColor = UIColor(
            red: 124 / 255,
            green: 80 / 255,
            blue: 45 / 255,
            alpha: 1.0
        )
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textAlignment = .center
        label.isUserInteractionEnabled = false // ✅ 터치 이벤트 버튼으로 전달

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)

        button.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        return button
    }
}

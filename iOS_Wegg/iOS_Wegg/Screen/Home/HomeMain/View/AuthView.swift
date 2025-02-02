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
    
    private let locationAuthButton = UIButton().then {
        $0.setupAuthButton(imageName: "locCert", title: "장소 인증하기")
    }
    
    private let photoAuthButton = UIButton().then {
        $0.setupAuthButton(imageName: "photoCert", title: "사진 인증하기")
    }

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
        photoAuthButton.addTarget(self, action: #selector(photoAuthTapped), for: .touchUpInside)
    }
    
    @objc private func locationAuthTapped() {
        print("장소 인증 터치 ✅")
    }

    @objc private func photoAuthTapped() {
        print("사진 인증 터치 ✅")
    }
}

// MARK: - UIButton Extension
private extension UIButton {
    func setupAuthButton(imageName: String, title: String) {
        self.then {
            $0.backgroundColor = .yellowWhite
            $0.layer.cornerRadius = 20
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.secondary.cgColor
            $0.isUserInteractionEnabled = true
        }
        
        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 8
            $0.isUserInteractionEnabled = false
        }
        
        let imageView = UIImageView(image: UIImage(named: imageName)).then {
            $0.contentMode = .scaleAspectFit
        }
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        
        let label = UILabel().then {
            $0.text = title
            $0.textColor = .secondary
            $0.font = .systemFont(ofSize: 10, weight: .bold)
            $0.textAlignment = .center
            $0.isUserInteractionEnabled = false
        }
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

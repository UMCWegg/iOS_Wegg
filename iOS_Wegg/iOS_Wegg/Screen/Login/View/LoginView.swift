//
//  LoginView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/9/25.
//

import UIKit

import SnapKit
import Then

class LoginView: UIView {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private let naverLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "Login/Naver/btnG_축약형"), for: .normal)
    }
    
    private let kakaoLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "Login/Kakao/kakao_login_medium_narrow"), for: .normal)
    }
    
    private let signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 13)
        $0.backgroundColor = .clear
    }
    
    private let emailLoginButton = UIButton().then {
        $0.setTitle("다른 방법으로 로그인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 13)
        $0.backgroundColor = .clear
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        [naverLoginButton,
         kakaoLoginButton,
         signUpButton,
         emailLoginButton].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        naverLoginButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(64)
            make.top.equalToSuperview().offset(363)
            make.height.equalTo(44)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(64)
            make.top.equalTo(naverLoginButton.snp.bottom).offset(24)
            make.height.equalTo(44)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.leading.equalTo(kakaoLoginButton.snp.leading).offset(18)
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(24)
            make.height.equalTo(44)
        }
        
        emailLoginButton.snp.makeConstraints { make in
            make.trailing.equalTo(kakaoLoginButton.snp.trailing).offset(-15)
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(24)
            make.height.equalTo(44)
        }
    }

}

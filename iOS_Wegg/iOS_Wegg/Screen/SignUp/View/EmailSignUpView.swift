//
//  EmailSignUpView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.27.
//

import UIKit

class EmailSignUpView: UIView {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "Login/BackButton"), for: .normal)
    }
    
    private let mainLabel = UILabel().then {
        $0.text = "이메일과 비밀번호를 입력해주세요"
        $0.font = UIFont.LoginFont.title
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
}

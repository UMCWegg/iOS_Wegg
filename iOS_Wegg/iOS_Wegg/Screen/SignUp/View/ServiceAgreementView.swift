//
//  ServiceAggrementView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.20.
//

import UIKit

class ServiceAggrementView: UIView {

    // MARK: - Font
    
    private let font = UIFont(name: "NotoSansKR-Regular", size: 15)
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private let serviceAgreementLabel = UILabel().then {
        $0.text = "서비스 이용 동의"
        $0.textColor = .black
        $0.font = UIFont(name: "NotoSansKR-Regular", size: 20)
    }
    
    private 

}

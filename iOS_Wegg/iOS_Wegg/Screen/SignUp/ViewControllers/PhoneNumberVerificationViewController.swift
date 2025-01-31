//
//  PhoneNumberVerificationViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.30.
//

import UIKit

class PhoneNumberVerificationViewController: UIViewController {
    
    // MARK: - Properties
    
    private let phoneNumberVerificationView = PhoneNumberVerificationView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = phoneNumberVerificationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
}

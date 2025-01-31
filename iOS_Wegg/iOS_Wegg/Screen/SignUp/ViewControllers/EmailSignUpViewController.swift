//
//  EmailSignUpViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.27.
//

import UIKit

class EmailSignUpViewController: UIViewController {

    // MARK: - Properties
    
    private let emailSignUpView = EmailSignUpView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = emailSignUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

}

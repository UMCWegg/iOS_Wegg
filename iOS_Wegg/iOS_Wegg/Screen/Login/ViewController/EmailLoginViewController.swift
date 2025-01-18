//
//  EmailLoginViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.18.
//

import UIKit

class EmailLoginViewController: UIViewController {

    // MARK: - Lifecycle
    
    override func loadView() {
        view = emailLoginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    // MARK: - Properties
    
    private let emailLoginView = EmailLoginView()
    
    

}

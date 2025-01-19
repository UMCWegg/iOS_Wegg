//
//  FindPasswordViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.19.
//

import UIKit

class FindPasswordViewController: UIViewController {

    // MARK: - Properties
    
    private let findPasswordView = FindPasswordView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = findPasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

}

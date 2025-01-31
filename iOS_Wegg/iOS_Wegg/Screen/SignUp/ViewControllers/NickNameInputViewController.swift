//
//  NickNameInputViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.31.
//

import UIKit

class NickNameInputViewController: UIViewController {

    // MARK: - Properties
    
    private let nickNameInputView = NickNameInputView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = nickNameInputView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

}

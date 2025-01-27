//
//  ServiceAggrementViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.20.
//

import UIKit

class ServiceAggrementViewController: UIViewController {

    // MARK: - Properties
    
    private let serviceAgreementView = ServiceAggrementView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = serviceAgreementView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

}

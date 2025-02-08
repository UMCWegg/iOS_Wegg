//
//  OccupationInputViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.31.
//

import UIKit

class OccupationInputViewController: UIViewController {

    // MARK: - Properties
    
    private let occupationInputView = OccupationInputView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = occupationInputView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupActions() {
        
        occupationInputView.nextButton.addTarget(self,
                                                 action: #selector(nextButtonTapped),
                                                 for: .touchUpInside)
        
        occupationInputView.backButton.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
        
        occupationInputView.occupationDropdown.didSelectOption = { [weak self] selectedOption in
            self?.handleOccupationSelection(selectedOption)
        }
    }
    
    // MARK: - Actions
    
    private func handleOccupationSelection(_ occupation: String) {
        guard let occupationType = UserOccupation(rawValue: occupation) else { return }
        
        // 선택된 직업 처리
        switch occupationType {
        case .employee:
            // 직장인 관련 처리
            break
        case .university:
            // 대학생 관련 처리
            break
        case .elementary:
            // 초등학생 관련 처리
            break
        case .secondary:
            // 중・고등학생 관련 처리
            break
        case .unemployed:
            // 무직 관련 처리
            break
        case .other:
            // 기타 관련 처리
            break
        }
        
        // 다음 화면으로 이동하거나 데이터 저장
        // moveToNextScreen()
    }
    
    @objc private func nextButtonTapped() {
        let reasonInputVC = ReasonInputViewController()
        navigationController?.pushViewController(reasonInputVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}

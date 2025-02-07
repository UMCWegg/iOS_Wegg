//
//  CameraViewController.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/8/25.
//

import UIKit

class CameraViewController: UIViewController {
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.customColor(.secondary)
        setNavigation()
        navigationController?.isNavigationBarHidden = false // 네비게이션 바 강제 표시
    }
    
    // MARK: - Methods
    
    /// 네비게이션 상단 바 타이틀 지정 및 나가기 버튼 커스텀
    private func setNavigation() {
        let titleView = UIView()
        // 로고 이미지로 스타일 변경
        let logoImageView = UIImageView(image: UIImage(named: "wegg_text"))
        logoImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logoImageView
        
        titleView.addSubview(logoImageView)
        
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(logoImageView.snp.height).multipliedBy(1.5) // 비율 유지
        }
        
        let backBtn = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(UIColor.white),
            style: .plain,
            target: self,
            action: #selector(didTap))
        navigationItem.leftBarButtonItem = backBtn
    }
    
    /// 네비게이션 왼쪽 상단 버튼을 통해 이전 화면으로 돌아감
    @objc func didTap() {
        navigationController?.popViewController(animated: true)
    }
    
}

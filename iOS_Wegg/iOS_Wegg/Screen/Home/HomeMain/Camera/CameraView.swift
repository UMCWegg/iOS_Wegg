//
//  CameraView.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/10/25.
//

import UIKit
import AVFoundation
import SnapKit
import Then

// MARK: - CameraView (카메라 관련 UI를 포함하는 뷰)
class CameraView: UIView {
    /// 카메라 미리보기 Layer층 선언
    private let previewView = PreviewView().then {
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    /// 앱 로고 이미지 뷰
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "wegg_text")
        $0.contentMode = .scaleAspectFit
    }
    
    /// 캡처 버튼
    let captureButton = UIButton().then {
        let image = UIImage(named: "camera_btn")?.withRenderingMode(.alwaysOriginal)
        $0.setImage(image, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI 설정 메서드
    private func setupUI() {
        addSubview(previewView)
        addSubview(logoImageView)
        addSubview(captureButton)
        setupConstraints()
    }
    
    // UI 제약조건 설정
    private func setupConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        previewView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.72)
        }
        
        captureButton.snp.makeConstraints { make in
            make.top.equalTo(previewView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(50)
        }
    }
    
    /// 카메라 미리보기 뷰 가져오기
    func getPreviewView() -> PreviewView {
        return previewView
    }
}

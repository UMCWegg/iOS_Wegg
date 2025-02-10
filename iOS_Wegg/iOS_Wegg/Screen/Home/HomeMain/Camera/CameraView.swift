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
    
    // MARK: - ProPerties
    
    /// 카메라 미리보기 Layer층 선언
    lazy var previewView = PreviewView().then {
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
    
    /// 인증하기 버튼
    let confirmButton = UIButton().then {
        $0.setTitle("인증하기", for: .normal)
        $0.backgroundColor = .customColor(.primary)
        $0.setTitleColor(.customColor(.secondary), for: .normal)
        $0.layer.cornerRadius = 15
        $0.isHidden = true
    }
    
    /// 촬영 후 표시할 이미지 컨테이너 뷰
    private let capturedImageContainer = UIView().then {
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.isHidden = true
    }
    
    /// 촬영후 사진 프로퍼티
    private var capturedImageView: UIImageView?
    
    // MARK: - Init
    
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
        addSubview(capturedImageContainer)
        addSubview(logoImageView)
        addSubview(captureButton)
        addSubview(confirmButton)
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
        
        capturedImageContainer.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.72)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(previewView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    /// 카메라 미리보기 뷰 가져오기
    func getPreviewView() -> PreviewView {
        return previewView
    }
    
    /// 촬영된 이미지를 표시 및 촬영전 UI 숨김처리
    /// 촬영된 이미지를 표시하고 기존 UI 숨김 처리
    func displayCapturedImage(_ image: UIImage) {
        // 기존 촬영된 이미지가 있으면 제거
        capturedImageView?.removeFromSuperview()
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill // 화면을 꽉 채우도록 설정해야 모서리 잘리는거 적용
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        
        capturedImageContainer.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // 부모 뷰(capturedImageContainer)와 동일한 크기로 설정
        }
        
        capturedImageView = imageView
        
        previewView.isHidden = true
        captureButton.isHidden = true
        
        capturedImageContainer.isHidden = false
        confirmButton.isHidden = false
    }
}

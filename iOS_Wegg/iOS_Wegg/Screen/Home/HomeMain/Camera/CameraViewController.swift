//
//  CameraViewController.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/8/25.
//

import AVFoundation
import UIKit

class CameraViewController: UIViewController {
    private let cameraView = CameraView()
    private let cameraSessionManager = CameraSessionManager()
    private var capturedImageView: UIImageView?
    
    override func loadView() {
        view = cameraView
        view.backgroundColor = .customColor(.secondary)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraSessionManager.delegate = self
        cameraSessionManager.configureSession(for: cameraView.getPreviewView())
        cameraSessionManager.startSession()
        setupButtonActions()
        confirmButtonActions()
        setupNavigation()
    }
    
    // 네비게이션 뒤로가기 버튼 설정
    private func setupNavigation() {
        navigationController?.isNavigationBarHidden = false
        let backBtn = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left")?
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(UIColor.white),
            style: .plain,
            target: self,
            action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = backBtn
    }
    
    // 촬영 버튼 액션 연결
    private func setupButtonActions() {
        cameraView.captureButton.addTarget(
            self, action: #selector(didTapCaptureButton),
            for: .touchUpInside)
    }
    
    // 인증하기 버튼 액션 연결
    private func confirmButtonActions() {
        cameraView.confirmButton.addTarget(
            self, action: #selector(didTapConfirmButton),
            for: .touchUpInside)
    }
    
    // MARK: - Button 관련 함수 정의
    
    @objc private func didTapCaptureButton() {
        cameraSessionManager.capturePhoto()
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapConfirmButton() {
        print("사진 인증 완료")
    }
}

// MARK: - CameraSessionManagerDelegate (촬영된 사진 처리)
extension CameraViewController: CameraSessionManagerDelegate {
    func didCapturePhoto(_ image: UIImage) {
        // 카메라 세션 종료
        cameraSessionManager.stopSession()
        
        /// CameraView 내부에서 촬영된 이미지 설정
        cameraView.displayCapturedImage(image)
        
    }
}

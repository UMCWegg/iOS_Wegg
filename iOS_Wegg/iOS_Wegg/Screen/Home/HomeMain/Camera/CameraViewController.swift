//
//  CameraViewController.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/8/25.
//

import AVFoundation
import UIKit

// MARK: - CameraViewController (카메라 기능을 제어하는 ViewController)
class CameraViewController: UIViewController {
    private let cameraView = CameraView()
    private let cameraSessionManager = CameraSessionManager()
    
    override func loadView() {
        view = cameraView
        view.backgroundColor = .customColor(.primary)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraSessionManager.delegate = self
        cameraSessionManager.configureSession(for: cameraView.getPreviewView())
        cameraSessionManager.startSession()
        setupButtonActions()
    }
    
    // 촬영 버튼 액션 연결
    private func setupButtonActions() {
        cameraView.captureButton.addTarget(
            self, action: #selector(didTapCaptureButton),
            for: .touchUpInside)
    }
    
    @objc private func didTapCaptureButton() {
        cameraSessionManager.capturePhoto()
    }
}

// MARK: - CameraSessionManagerDelegate (촬영된 사진 처리)
extension CameraViewController: CameraSessionManagerDelegate {
    func didCapturePhoto(_ image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = view.bounds
        view.addSubview(imageView)
    }
}

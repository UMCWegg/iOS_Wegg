//
//  CameraViewController.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/8/25.
//

import AVFoundation
import UIKit

// MARK: - CameraViewController
class CameraViewController: UIViewController {
    private let previewView = PreviewView().then {
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    private let logoimageView = UIImageView().then {
        $0.image = UIImage(named: "wegg_text")
        $0.contentMode = .scaleAspectFit
    }
    
    private let captureButton = UIButton().then {
        let image = UIImage(named: "camera_btn")?.withRenderingMode(.alwaysOriginal)
        $0.setImage(image, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    private let cameraSessionManager = CameraSessionManager()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .customColor(.primary)
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraSessionManager.delegate = self
        cameraSessionManager.configureSession(for: previewView)
        cameraSessionManager.startSession()
    }
    
    private func setupUI() {
        view.addSubview(logoimageView)
        view.addSubview(previewView)
        view.addSubview(captureButton)
        
        logoimageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        
        previewView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.75)
        }
        
        captureButton.snp.makeConstraints { make in
            make.top.equalTo(previewView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(40)
        }
        
        captureButton.addTarget(self, action: #selector(didTapCaptureButton), for: .touchUpInside)
    }
    
    @objc private func didTapCaptureButton() {
        cameraSessionManager.capturePhoto()
    }
}

// MARK: - CameraSessionManagerDelegate
extension CameraViewController: CameraSessionManagerDelegate {
    func didCapturePhoto(_ image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = view.bounds
        view.addSubview(imageView)
    }
}

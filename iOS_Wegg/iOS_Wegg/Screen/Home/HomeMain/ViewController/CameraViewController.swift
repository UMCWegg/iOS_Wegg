//
//  CameraViewController.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/8/25.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    // MARK: - Properties
    private var captureSession: AVCaptureSession? // 카메라 세션
    private let cameraPreviewView = CameraPreviewView() // 뷰 생성
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = cameraPreviewView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        navigationController?.isNavigationBarHidden = false // 네비게이션 바 강제 표시
        checkCameraAuth() // ✅ 카메라 권한 확인
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCamera() // ✅ 카메라 설정
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
    
    // MARK: - Test
    
    private func checkCameraAuth() {
           switch AVCaptureDevice.authorizationStatus(for: .video) {
           case .authorized:
               setupCamera()
           case .notDetermined:
               AVCaptureDevice.requestAccess(for: .video) { granted in
                   DispatchQueue.main.async {
                       if granted {
                           self.setupCamera()
                       } else {
                           self.showPermissionAlert()
                       }
                   }
               }
           case .denied, .restricted:
               showPermissionAlert()
           @unknown default:
               fatalError("Unhandled case")
           }
       }

       private func setupCamera() {
           captureSession?.sessionPreset = .photo

           guard let camera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video, position: .back),
                 let input = try? AVCaptureDeviceInput(device: camera),
           ((captureSession?.canAddInput(input)) != nil) else {
               print("❌ 카메라 설정 실패")
               return
           }

           captureSession?.addInput(input)
           cameraPreviewView.session = captureSession // ✅ 카메라 미리보기 연결

           DispatchQueue.global(qos: .background).async {
               self.captureSession?.startRunning() // ✅ 비동기 실행으로 성능 최적화
           }
       }

       private func showPermissionAlert() {
           let alert = UIAlertController(
               title: "카메라 접근 권한 필요",
               message: "설정에서 카메라 접근을 허용해주세요.",
               preferredStyle: .alert
           )
           alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
               guard let settingsURL = URL(
                string: UIApplication.openSettingsURLString) else { return }
               UIApplication.shared.open(settingsURL)
           })
           alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
           present(alert, animated: true)
       }
}

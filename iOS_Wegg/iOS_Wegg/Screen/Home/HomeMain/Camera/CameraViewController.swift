//
//  CameraViewController.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/8/25.
//

import AVFoundation
import UIKit

class CameraViewController: UIViewController {
    
    // MARK: - Property
    
    private let cameraView = CameraView()
    private let cameraSessionManager = CameraSessionManager()
    private var capturedImageView: UIImageView?
    private var capturedImage: UIImage? // 촬영한 이미지를 저장하는 변수
    
    // MARK: - Init
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
    
    // MARK: - Methods
    /// 네비게이션 뒤로가기 버튼 설정
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
    
    /// 촬영 버튼 액션 연결
    private func setupButtonActions() {
        cameraView.captureButton.addTarget(
            self, action: #selector(didTapCaptureButton),
            for: .touchUpInside)
    }
    
    /// 인증하기 버튼 액션 연결
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
        prepareUploadRequest()
    }

    /// 🔹 API 요청을 준비하는 함수
    private func prepareUploadRequest() {
        guard let image = capturedImage else {
            print("❌ 오류: 촬영된 이미지가 없습니다.")
            showUploadResultAlert(isSuccess: false, message: "촬영된 이미지가 없습니다. 다시 촬영해주세요.")
            return
        }
        
        let planId = "1"  // 🔹 실제 사용 시 필요한 planId 값을 설정해야 함
        print("📸 인증 요청 - API 호출 준비 중... (planId: \(planId))")
        
        uploadCapturedImage(image, planId: planId)
    }

    /// 🔹 API 호출을 실행하는 함수
    private func uploadCapturedImage(_ image: UIImage, planId: String) {
        let postService = PostService()
        
        Task {
            do {
                let response = try await postService.uploadPost(image: image, planId: planId)
                print("✅ 업로드 성공: postId = \(response.result.postId)")
                print("📅 생성 시간: \(response.result.createdAt)")
                
                DispatchQueue.main.async {
                    self.showUploadResultAlert(isSuccess: true, message: "게시물이 등록되었습니다!")
                }
                
            } catch {
                print("❌ 업로드 실패: \(error)")
                DispatchQueue.main.async {
                    self.showUploadResultAlert(isSuccess: false, message: "업로드 실패. 다시 시도해주세요.")
                }
            }
        }
    }
    
    /// 업로드 결과에 따라 Alert 표시
    private func showUploadResultAlert(isSuccess: Bool, message: String) {
        let alertTitle = isSuccess ? "업로드 완료" : "업로드 실패"
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            if isSuccess {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
}

// MARK: - CameraSessionManagerDelegate (촬영된 사진 처리)
extension CameraViewController: CameraSessionManagerDelegate {
    func didCapturePhoto(_ image: UIImage) {
        // 카메라 세션 종료
        cameraSessionManager.stopSession()
        // 촬영한 사진 저장하기
        capturedImage = image
        /// CameraView 내부에서 촬영된 이미지 설정
        cameraView.displayCapturedImage(image)
    }
}

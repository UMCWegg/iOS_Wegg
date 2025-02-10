//
//  File.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/10/25.
//

import UIKit
import AVFoundation

// MARK: - CameraSessionManagerDelegate
/// 사진 촬영이 완료되었을 때 호출되는 델리게이트 프로토콜
protocol CameraSessionManagerDelegate: AnyObject {
    func didCapturePhoto(_ image: UIImage) // 촬영된 사진을 전달하는 메서드
}

// MARK: - CameraSessionManager
/// 카메라 세션을 관리하는 클래스
final class CameraSessionManager: NSObject {
    private let captureSession = AVCaptureSession() // 카메라 세션 객체
    private let photoOutput = AVCapturePhotoOutput() // 사진 촬영을 위한 AVCapturePhotoOutput 객체
    weak var delegate: CameraSessionManagerDelegate? // 촬영 결과를 전달할 델리게이트
    
    private var previewLayer: AVCaptureVideoPreviewLayer? // 미리보기 레이어
    
    // MARK: - 카메라 세션 설정
    /// 카메라 세션을 설정하는 메서드
    /// - Parameter previewView: 미리보기를 표시할 PreviewView
    func configureSession(for previewView: PreviewView) {
        captureSession.sessionPreset = .photo // 사진 촬영 품질 설정
        
        // 후면 카메라 가져오기
        guard let backCamera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video, position: .back) else {
            print("Back camera not available")
            return
        }
        
        do {
            // 카메라 입력 장치 설정
            let input = try AVCaptureDeviceInput(device: backCamera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            // 사진 촬영 출력을 세션에 추가
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            // 미리보기 레이어 설정
            previewLayer = previewView.videoPreviewLayer
            previewLayer?.session = captureSession
            previewLayer?.videoGravity = .resizeAspectFill
        } catch {
            print("Error setting up camera input: \(error)")
        }
    }
    
    // MARK: - 카메라 세션 시작
    /// 카메라 세션을 실행하는 메서드
    func startSession() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
    // MARK: - 카메라 세션 중지
    /// 카메라 세션을 중지하는 메서드
    func stopSession() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession.stopRunning()
        }
    }
    
    // MARK: - 사진 촬영
    /// 사진을 촬영하는 메서드
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .off // 플래시 비활성화
        photoOutput.capturePhoto(with: settings, delegate: self) // 사진 촬영 실행
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraSessionManager: AVCapturePhotoCaptureDelegate {
    // MARK: - 촬영된 사진 처리
    /// 촬영된 사진을 처리하는 메서드
    /// - Parameters:
    ///   - output: 사진 촬영을 담당하는 AVCapturePhotoOutput
    ///   - photo: 촬영된 AVCapturePhoto 객체
    ///   - error: 촬영중 발생한 오류 (있다면)
    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?) {
        
        // 촬영된 사진 데이터를 변환하여 UIImage로 변환
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            print("Error capturing photo: \(String(describing: error))")
            return
        }
        
        // 델리게이트를 통해 촬영된 사진 전달
        delegate?.didCapturePhoto(image)
    }
}

//
//  File.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/10/25.
//

import UIKit
import AVFoundation

protocol CameraSessionManagerDelegate: AnyObject {
    func didCapturePhoto(_ image: UIImage)
}

final class CameraSessionManager: NSObject {
    private let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    weak var delegate: CameraSessionManagerDelegate?
    
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    func configureSession(for previewView: PreviewView) {
        captureSession.sessionPreset = .photo
        
        guard let backCamera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video, position: .back) else {
            print("Back camera not available")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            previewLayer = previewView.videoPreviewLayer
            previewLayer?.session = captureSession
            previewLayer?.videoGravity = .resizeAspectFill
        } catch {
            print("Error setting up camera input: \(error)")
        }
    }
    
    func startSession() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
    func stopSession() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession.stopRunning()
        }
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .off
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraSessionManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?) {
            guard let imageData = photo.fileDataRepresentation(),
                  let image = UIImage(data: imageData) else {
                print("Error capturing photo: \(String(describing: error))")
                return
            }
            delegate?.didCapturePhoto(image)
        }
}

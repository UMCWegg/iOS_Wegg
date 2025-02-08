//
//  CameraPreview.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/8/25.
//

import UIKit
import AVFoundation
import SnapKit

/// `AVCaptureVideoPreviewLayer`를 설정하여 실시간 카메라 미리보기 제공
/// `session` 프로퍼티를 통해 `AVCaptureSession`을 연결하여 카메라 영상을 출력
class CameraPreviewView: UIView {
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI() // ✅ UI 설정을 한 곳에서 관리
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: - AVCaptureVideoPreviewLayer 설정
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    /// `AVCaptureVideoPreviewLayer`를 안전하게 가져오는 프로퍼티
    var previewLayer: AVCaptureVideoPreviewLayer {
        guard let previewLayer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("AVCaptureVideoPreviewLayer를 가져올 수 없습니다.")
        }
        return previewLayer
    }
    
    /// `session` 프로퍼티를 통해 `AVCaptureSession`을 연결하여 카메라 영상을 출력
    var session: AVCaptureSession? {
        get { previewLayer.session }
        set { previewLayer.session = newValue }
    }
    
    // MARK: - UI 설정
    private func setupUI() {
        backgroundColor = UIColor.customColor(.secondary) // 초기 배경색 설정
        layer.cornerRadius = 20
        clipsToBounds = true
    }
}

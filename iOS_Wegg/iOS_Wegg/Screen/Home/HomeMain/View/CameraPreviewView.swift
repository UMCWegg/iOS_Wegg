//
//  CameraPreview.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/8/25.
//

import UIKit
import AVFoundation
import SnapKit

class CameraPreviewView: UIView {
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.customColor(.secondary)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        setupUI()
    }
    
    // MARK: - Test
    
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer? {
        return layer as? AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get { previewLayer?.session }
        set { previewLayer?.session = newValue }
    }
    
    private func setupUI() {
        backgroundColor = .black
        layer.cornerRadius = 20
        clipsToBounds = true
        
        snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9) // ✅ 너비 90%
            make.height.equalToSuperview().multipliedBy(0.75) // ✅ 높이 75%
        }
    }
}

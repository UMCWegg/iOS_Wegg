//
//  Preview.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/10/25.
//

import UIKit
import AVFoundation

class PreviewView: UIView {
    /// 카메라 미리보기 Layer층 선언
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("PreviewView's layer is not AVCaptureVideoPreviewLayer")
        }
        return layer
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}

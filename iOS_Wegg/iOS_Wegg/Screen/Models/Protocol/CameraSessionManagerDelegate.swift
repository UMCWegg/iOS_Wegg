//
//  File.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/10/25.
//

import UIKit
// MARK: - CameraSessionManagerDelegate
/// 사진 촬영이 완료되었을 때 호출되는 델리게이트 프로토콜
protocol CameraSessionManagerDelegate: AnyObject {
    func didCapturePhoto(_ image: UIImage) // 촬영된 사진을 전달하는 메서드
}

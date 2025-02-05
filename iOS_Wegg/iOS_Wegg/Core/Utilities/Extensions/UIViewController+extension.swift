//
//  UINavigationController+extension.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/4/25.
//

import UIKit

extension UIViewController {
    
    /// 커스텀 애니메이션을 사용한 화면 전환 (Push/Pop)
    ///
    /// - Parameters:
    ///   - viewController: 이동할 대상 ViewController
    ///   - isPush: `true`이면 push, `false`이면 pop 동작
    ///   - duration: 애니메이션 지속 시간
    ///   - type: 애니메이션 타입
    ///   - subtype: 애니메이션 방향
    func customNavigationAnimation(
        to viewController: UIViewController?,
        isPush: Bool,
        duration: CFTimeInterval = 0.2,
        type: CATransitionType = .fade,
        subtype: CATransitionSubtype = .fromRight
    ) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = type
        transition.subtype = subtype
        
        view.layer.add(transition, forKey: nil)
        
        if let navigationController = self.navigationController {
            /// `navigationController`가 있으면 Push 또는 Pop 실행
            if isPush, let viewController = viewController {
                navigationController.pushViewController(viewController, animated: false)
            } else {
                navigationController.popViewController(animated: false)
            }
        } else {
            /// `navigationController`가 없으면 Present 또는 Dismiss 실행
            if isPush, let viewController = viewController {
                viewController.modalPresentationStyle = .fullScreen
                present(viewController, animated: false, completion: nil)
            } else {
                dismiss(animated: false, completion: nil)
            }
        }
    }
}

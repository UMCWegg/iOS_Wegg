import UIKit

extension UIViewController {
    
    /// 커스텀 애니메이션을 사용한 화면 전환 (Push/Pop or Present/Dismiss)
    ///
    /// - Parameters:
    ///   - viewController: 이동할 대상 ViewController (Push/Present 시 필요)
    ///   - isPush: `true`이면 push/present, `false`이면 pop/dismiss 동작
    ///   - duration: 애니메이션 지속 시간 (기본값: 0.2초)
    ///   - type: 애니메이션 타입 (기본값: `.fade`)
    func customNavigationAnimation(
        to requiredViewController: UIViewController? = nil,
        isPush: Bool,
        duration: CFTimeInterval = 0.2,
        type: CATransitionType = .fade
    ) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = type
        transition.subtype = isPush ? .fromRight : .fromLeft  // 자동 방향 설정
        
        view.layer.add(transition, forKey: nil)
        
        if let navigationController = self.navigationController {
            if isPush, let viewController = requiredViewController {
                navigationController.pushViewController(viewController, animated: false)
            } else {
                navigationController.popViewController(animated: false)
            }
        } else {
            if isPush, let viewController = requiredViewController {
                viewController.modalPresentationStyle = .fullScreen
                present(viewController, animated: false, completion: nil)
            } else if self.presentedViewController != nil {  // 현재 모달이 떠 있을 때만 dismiss 실행
                dismiss(animated: false, completion: nil)
            }
        }
    }
    
    /// 화면 터치 시 키보드를 내리는 기능 추가
    func addKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // 다른 UI 요소의 터치 이벤트도 정상적으로 동작하게 함
        view.addGestureRecognizer(tapGesture)
    }

    /// 키보드를 내리는 메서드
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

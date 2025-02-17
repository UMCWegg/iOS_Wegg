//
//  ScheduleTimeView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/17/25.
//

import UIKit
import Then
import SnapKit

protocol ScheduleViewDelegate: AnyObject {
    func didTapCancelButton()
    func didTapConfirmButton()
    func didTimeChanged(_ sender: UIDatePicker)
}

class ScheduleTimeView: UIView {
    
    weak var delegate: ScheduleViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .primary
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "랜덤인증"
        $0.font = .notoSans(.medium, size: 20)
        $0.textColor = .secondary
        $0.textAlignment = .center
    }
    
    private lazy var timePicker = UIDatePicker().then {
        $0.datePickerMode = .time
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko_KR")
        $0.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
    }
    
    private lazy var confirmButton = makeButton(title: "확인").then {
        $0.addTarget(
            self,
            action: #selector(confirmButtonHandler),
            for: .touchUpInside
        )
    }
    private lazy var cancelButton = makeButton(title: "취소").then {
        $0.addTarget(
            self,
            action: #selector(cancelButtonHandler),
            for: .touchUpInside
        )
    }
    
    /// 버튼 생성 함수
    private func makeButton(title: String) -> UIButton {
        return UIButton().then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(.secondary, for: .normal)
            $0.titleLabel?.font = .notoSans(.medium, size: 16)
        }
    }
    
    // MARK: - Handler
    
    @objc private func timeChanged(_ sender: UIDatePicker) {
        delegate?.didTimeChanged(sender)
    }
    
    @objc private func cancelButtonHandler() {
        delegate?.didTapCancelButton()
    }
    
    @objc private func confirmButtonHandler() {
        delegate?.didTapConfirmButton()
    }
    
    private func setupView() {
        [
            timePicker,
            confirmButton,
            cancelButton,
            titleLabel
        ].forEach(addSubview)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
        }
        
        timePicker.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(90)
            make.centerX.equalToSuperview()
        }
        
        [confirmButton, cancelButton].forEach { button in
            button.snp.makeConstraints { make in
                if button == confirmButton {
                    make.trailing.lessThanOrEqualToSuperview().offset(-21)
                } else {
                    make.leading.lessThanOrEqualToSuperview().offset(21)
                }
                make.bottom.equalToSuperview().offset(-37)
                make.width.equalTo(30)
            }
        }
    }
}

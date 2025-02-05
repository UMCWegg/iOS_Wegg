//
//  PlaceDetailView.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/5/25.
//

import UIKit
import Then
import SnapKit

class PlaceDetailView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var iconImageView = UIImageView().then {
        $0.image = UIImage(named: "wegg_icon2")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var styledVisitorCountLabel = UILabel().then {
        let fullText = NSMutableAttributedString()
        
        let visitorCountText = NSAttributedString(
            string: "132명의 ",
            attributes: [
            .font: UIFont.notoSans(.medium, size: 12) ?? UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.primary
        ])
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "weggy")
        imageAttachment.bounds = CGRect(x: 0, y: -2, width: 50, height: 12)
        
        let weggyAttributedString = NSAttributedString(attachment: imageAttachment)

        let visitedPlaceText = NSAttributedString(
            string: " 가 이 장소를 방문하였어요",
            attributes: [
            .font: UIFont.notoSans(.medium, size: 12) ?? UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.primary
        ])

        fullText.append(visitorCountText)
        fullText.append(weggyAttributedString)
        fullText.append(visitedPlaceText)
        
        $0.attributedText = fullText
    }
    
    private lazy var titleStackView = makeStackView(spacing: 8, axis: .horizontal)
    
    // MARK: - Function
    
    func makeStackView(
        spacing: CGFloat,
        axis: NSLayoutConstraint.Axis
    ) -> UIStackView {
        let stack = UIStackView()
        stack.axis = axis
        stack.spacing = spacing
        stack.distribution = .fill
        
        return stack
    }
}

private extension PlaceDetailView {
    func setupView() {
        setupStackView()
        addComponents()
        constraints()
    }
    
    func setupStackView() {
        [iconImageView, styledVisitorCountLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(
                MapViewLayout.yellowLogoIcon
            )
        }
        
        styledVisitorCountLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(222)
        }
    }
    
    func addComponents() {
        [titleStackView].forEach {
            addSubview($0)
        }
    }
    
    func constraints() {
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(21)
            make.trailing.greaterThanOrEqualToSuperview().inset(100)
        }
    }
}

//
//  SettingBackButton.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.18.
//

import UIKit

class SettingBackButton: UIButton {
   
   // MARK: - Init
   
   override init(frame: CGRect) {
       super.init(frame: frame)
       setupButton()
   }
   
   required init?(coder: NSCoder) {
       super.init(coder: coder)
       setupButton()
   }
   
   // MARK: - Setup
   
   private func setupButton() {
       setImage(UIImage(systemName: "chevron.left"), for: .normal)
       tintColor = .secondary
       contentMode = .scaleAspectFit
       
       translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
           widthAnchor.constraint(equalToConstant: 10),
           heightAnchor.constraint(equalToConstant: 20)
       ])
   }
}

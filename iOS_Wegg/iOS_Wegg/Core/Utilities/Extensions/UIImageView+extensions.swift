//
//  UIImageView+extensions.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/13/25.
//

import Foundation
import UIKit

extension UIImageView {
    /// 네트워크 이미지를 로드하고, 실패 시 로컬 placeholder 이미지를 표시
    func loadImage(from urlString: String?, placeholder: String) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = UIImage(named: placeholder) // ✅ 지정된 placeholder 사용
            return
        }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.image = UIImage(named: placeholder) // ✅ 네트워크 실패 시 지정된 placeholder 사용
                }
            }
        }
    }
}

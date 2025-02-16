//
//  UIView+extensions.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/14/25.
//

import UIKit

extension UIView {
    func toImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
}

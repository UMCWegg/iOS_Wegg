//
//  UIFont+extensions.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/20/25.
//

import Foundation
import UIKit

extension UIFont {
    enum GmarketSansStyle: String {
        case bold = "GmarketSansTTFBold"
        case medium = "GmarketSansTTFMedium"
        case light = "GmarketSansTTFLight"
    }

    enum NotoSansStyle: String {
        case medium = "NotoSansKR-Medium"
        case regular = "NotoSansKR-Regular"
    }

    static func gmarketSans(_ type: GmarketSansStyle, size: CGFloat) -> UIFont? {
        return UIFont(name: type.rawValue, size: size)
    }

    static func notoSans(_ type: NotoSansStyle, size: CGFloat) -> UIFont? {
        return UIFont(name: type.rawValue, size: size)
    }
}

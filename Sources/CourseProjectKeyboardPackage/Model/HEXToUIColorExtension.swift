//
//  HEXToUIColorExtension.swift
//  CourseProject
//
//  Created by Anastasia on 07.03.2022.
//

import UIKit

public protocol HEXtoUIColorDelegate {
    static func HEXToUIColor(color: String, alpha: CGFloat) -> UIColor
}

extension UIColor: HEXtoUIColorDelegate {
    public static func HEXToUIColor(color: String, alpha: CGFloat = 1) -> UIColor {
        func getColorFloat(_ color: UInt64, _ mask: UInt64, _ offset: Int = 0) -> CGFloat {
            CGFloat((color & mask) >> offset) / 255.0
        }
        
        if (color.count != 6) {
            return UIColor.clear
        }
        
        var colorInRGB: UInt64 = 0
        Scanner(string: color.uppercased()).scanHexInt64(&colorInRGB)
        
        if #available(iOS 10.0, *) {
            return UIColor(
                displayP3Red: getColorFloat(colorInRGB, 0xFF0000, 16),
                green: getColorFloat(colorInRGB, 0x00FF00, 8),
                blue: getColorFloat(colorInRGB, 0x0000FF),
                alpha: alpha
            )
        }
        return UIColor(
            red: getColorFloat(colorInRGB, 0xFF0000, 16),
            green: getColorFloat(colorInRGB, 0x00FF00, 8),
            blue: getColorFloat(colorInRGB, 0x0000FF),
            alpha: alpha
        )
    }
}

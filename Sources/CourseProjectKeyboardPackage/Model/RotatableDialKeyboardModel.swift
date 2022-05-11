//
//  RotatableDialKeyboardModel.swift
//
//
//  Created by Anastasia on 22.03.2022.
//

import UIKit

public struct RotatableDialKeyboardModel {
    var currentKeyboard: String?
    var isRotating = false
    var languages: [String: [DialSlice]]
    var languagesSequence: [String]
    
    public struct DialSlice {
        var degrees: CGFloat
        var distanceCenterToButtonCenter: CGFloat
        
        var layerGradient: Gradient?
        var layerColor: UIColor?
        
        var keys: [DialKey]
        var shiftedKeys: [String]?
        
        var height: Double
        
        var shadowColor: CGColor?
        var shadowOffset: CGSize?
        var shadowOpacity: Float?
    }
    
    public struct DialKey {
        var textField: UITextInput
        var content: String
        
        var cornerRadius: CGFloat?
        var borderWidth: CGFloat?
        var borderColor: CGColor?
        
        var gradient: Gradient?
        var color: UIColor?
        var textColor: UIColor?
        
        var height: Double
        var width: Double
        
        var shadowColor: CGColor?
        var shadowOffset: CGSize?
        var shadowOpacity: Float?
        
        var specialButtonType: RotatableDialKeyboardSpecialButtons?
        var image: UIImage?
        
        var function: ((UIButton) -> ())?
    }
    
    public struct Gradient {
        var colorTop: CGColor
        var colorBottom: CGColor
        
        public init(colorTop: CGColor, colorBottom: CGColor) {
            self.colorTop = colorTop
            self.colorBottom = colorBottom
        }
    }
}

//
//  RotatableDialKeyboardModel.swift
//
//
//  Created by Anastasia on 22.03.2022.
//

import UIKit

public struct RotatableDialKeyboardModel {
    public var currentKeyboard: String?
    public var isRotating = false
    public var languages: [String: [DialSlice]]
    public var languagesSequence: [String]
    
    public struct DialSlice {
        public var degrees: CGFloat
        public var distanceCenterToButtonCenter: CGFloat
        
        public var layerGradient: Gradient?
        public var layerColor: UIColor?
        
        public var keys: [DialKey]
        public var shiftedKeys: [String]?
        
        public var height: Double
        
        public var shadowColor: CGColor?
        public var shadowOffset: CGSize?
        public var shadowOpacity: Float?
        
        public init(
            degrees: CGFloat,
            distanceCenterToButtonCenter: CGFloat,
            layerGradient: Gradient? = nil,
            layerColor: UIColor? = nil,
            keys: [DialKey],
            shiftedKeys: [String]? = nil,
            height: Double,
            shadowColor: CGColor? = nil,
            shadowOffset: CGSize? = nil,
            shadowOpacity: Float? = nil
        ) {
            self.degrees = degrees
            self.distanceCenterToButtonCenter = distanceCenterToButtonCenter
            self.layerGradient = layerGradient
            self.layerColor = layerColor
            self.keys = keys
            self.shiftedKeys = shiftedKeys
            self.height = height
            self.shadowColor = shadowColor
            self.shadowOffset = shadowOffset
            self.shadowOpacity = shadowOpacity
        }
    }
    
    public struct DialKey {
        public var textField: UITextInput
        public var content: String
        
        public var cornerRadius: CGFloat?
        public var borderWidth: CGFloat?
        public var borderColor: CGColor?
        
        public var gradient: Gradient?
        public var color: UIColor?
        public var textColor: UIColor?
        
        public var height: Double
        public var width: Double
        
        public var shadowColor: CGColor?
        public var shadowOffset: CGSize?
        public var shadowOpacity: Float?
        
        public var specialButtonType: RotatableDialKeyboardSpecialButtons?
        public var image: UIImage?
        
        public var function: ((UIButton) -> ())?
        
        public init(
            textField: UITextInput,
            content: String,
            cornerRadius: CGFloat? = nil,
            borderWidth: CGFloat? = nil,
            borderColor: CGColor? = nil,
            gradient: Gradient? = nil,
            color: UIColor? = nil,
            textColor: UIColor? = nil,
            height: Double,
            width: Double,
            shadowColor: CGColor? = nil,
            shadowOffset: CGSize? = nil,
            shadowOpacity: Float? = nil,
            specialButtonType: RotatableDialKeyboardSpecialButtons? = nil,
            image: UIImage? = nil,
            function: ((UIButton) -> ())? = nil
        ) {
            self.textField = textField
            self.content = content
            self.cornerRadius = cornerRadius
            self.borderWidth = borderWidth
            self.borderColor = borderColor
            self.gradient = gradient
            self.color = color
            self.textColor = textColor
            self.height = height
            self.width = width
            self.shadowColor = shadowColor
            self.shadowOffset = shadowOffset
            self.shadowOpacity = shadowOpacity
            self.specialButtonType = specialButtonType
            self.image = image
            self.function = function
            
        }
    }
    
    public struct Gradient {
        public var colorTop: CGColor
        public var colorBottom: CGColor
        
        public init(colorTop: CGColor, colorBottom: CGColor) {
            self.colorTop = colorTop
            self.colorBottom = colorBottom
        }
    }
    
    public init(
        currentKeyboard: String = "",
        isRotating: Bool = false,
        languages: [String: [DialSlice]],
        languagesSequence: [String]
    ) {
        self.currentKeyboard = currentKeyboard
        self.isRotating = isRotating
        self.languages = languages
        self.languagesSequence = languagesSequence
    }
}


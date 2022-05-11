//
//  KeyboardButton.swift
//
//
//  Created by Anastasia on 22.03.2022.
//

import UIKit

public final class RotatableDialKeyboardButton: UIView {
    var model: RotatableDialKeyboardModel.DialKey?
    var button = UIButton(type: .system)
    
    public weak var changingAlphabetsDelegate: KeyboardChangingAlphabetsDelegate?
    public weak var shiftDelegate: KeyboardShiftDelegate?
    
    public init(_ model: RotatableDialKeyboardModel.DialKey) {
        super.init(frame: .zero)
        
        self.model = model
        configureButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        guard let model = model else { return }
        
        addSubview(button)
        button.pin(to: self)
        button.setHeight(to: model.height)
        button.setWidth(to: model.width)
        
        button.setTitle(model.content, for: .normal)
        button.setTitleColor(model.textColor, for: .normal)
        
        button.layer.borderWidth = model.borderWidth ?? 0
        button.layer.borderColor = model.borderColor ?? UIColor.clear.cgColor
        
        if (model.color != nil) {
            button.backgroundColor = model.color
        } else {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [
                model.gradient?.colorTop ?? UIColor.clear,
                model.gradient?.colorBottom ?? UIColor.clear
            ]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.frame = CGRect(
                x: 0,
                y: 0,
                width: model.height,
                height: model.height
            )
            
            button.layer.insertSublayer(gradientLayer, at:0)
        }
        
        if (model.image != nil) {
            button.setImage(model.image, for: .normal)
        }
        
        button.layer.cornerRadius = model.cornerRadius ?? 0
        button.clipsToBounds = true
        
        if (model.shadowColor != nil) {
            configureButtonShadow(
                shadowColor: model.shadowColor,
                shadowOffset: model.shadowOffset,
                shadowOpacity: model.shadowOpacity
            )
        }
        
        if (model.specialButtonType != nil) {
            guard let type = model.specialButtonType else { return }
            configureSpecialButton(buttonType: type)
        } else if (model.function != nil) {
            button.addTarget(
                self,
                action: #selector(userButtonWasTapped),
                for: .touchUpInside
            )
        } else {
            button.addTarget(
                self,
                action: #selector(buttonWasPressed),
                for: .touchUpInside
            )
        }
    }
    
    @objc
    func userButtonWasTapped() {
        guard let function = model?.function else { return }
        function(self.button)
    }
    
    private func configureSpecialButton(buttonType: RotatableDialKeyboardSpecialButtons) {
        switch buttonType {
        case .eraseButton:
            button.addTarget(
                self,
                action: #selector(eraseButtonWasPressed),
                for: .touchUpInside
            )
        case .shiftButton:
            button.addTarget(
                self,
                action: #selector(shiftButtonWasPressed),
                for: .touchUpInside
            )
        case .globeButton:
            button.addTarget(
                self,
                action: #selector(globeButtonWasPressed),
                for: .touchUpInside
            )
        case .returnButton:
            button.addTarget(
                self,
                action: #selector(returnButtonWasPressed),
                for: .touchUpInside
            )
        case .spaceButton:
            button.addTarget(
                self,
                action: #selector(spaceButtonWasPressed),
                for: .touchUpInside
            )
        }
    }
    
    @objc
    private func buttonWasPressed(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else { return }
        
        model?.textField.insertText(text)
    }
    
    @objc
    private func eraseButtonWasPressed(_ sender: UIButton) {
        model?.textField.deleteBackward()
    }
    
    @objc
    private func globeButtonWasPressed(_ sender: UIButton) {
        self.changingAlphabetsDelegate?.changeAlphabetsKeyWasTapped()
    }
    
    @objc
    private func shiftButtonWasPressed(_ sender: UIButton) {
        self.shiftDelegate?.shiftKeyWasTapped()
    }
    
    @objc
    private func returnButtonWasPressed(_ sender: UIButton) {
        if (model?.textField is UITextField) {
            guard let textField = model?.textField else { return }
            (textField as! UITextField).endEditing(true)
        } else if (model?.textField is UITextView) {
            guard let textField = model?.textField else { return }
            (textField as! UITextView).endEditing(true)
        }
    }
    
    @objc
    private func spaceButtonWasPressed(_ sender: UIButton) {
        model?.textField.insertText(" ")
    }
    
    private func configureButtonShadow(
        shadowColor: CGColor?,
        shadowOffset: CGSize?,
        shadowOpacity: Float?
    ) {
        button.layer.shadowColor = shadowColor
        button.layer.shadowOffset = shadowOffset ?? CGSize()
        button.layer.shadowOpacity = shadowOpacity ?? 0
        button.layer.shadowRadius = 0.0
        button.layer.masksToBounds = false
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (model?.specialButtonType != nil) {
            switch model?.specialButtonType {
            case .eraseButton:
                eraseButtonWasPressed(self.button)
            case .shiftButton:
                shiftButtonWasPressed(self.button)
            case .globeButton:
                globeButtonWasPressed(self.button)
            case .returnButton:
                returnButtonWasPressed(self.button)
            case .spaceButton:
                spaceButtonWasPressed(self.button)
            case .none:
                return
            }
        } else if (model?.function != nil) {
            guard let function = model?.function else { return }
            function(self.button)
        } else {
            buttonWasPressed(self.button)
        }
    }
}


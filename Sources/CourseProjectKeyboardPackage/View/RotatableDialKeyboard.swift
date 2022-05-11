//
//  RotatableDialKeyboard.swift
//
//
//  Created by Anastasia on 18.03.2022.
//

import UIKit

public protocol KeyboardShiftDelegate: AnyObject {
    func shiftKeyWasTapped()
}

public protocol KeyboardChangingAlphabetsDelegate: AnyObject {
    func changeAlphabetsKeyWasTapped()
}

public final class RotatableDialKeyboard: UIView {
    var model: RotatableDialKeyboardModel?
    var alphabets: [String: [RotatableDialKeyboardLayer]] = [:]
    var currentAlphabet: String = ""
    
    public init(model: RotatableDialKeyboardModel, frame: CGRect) {
        super.init(frame: frame)
        
        self.model = model
        
        configureLayers(model: model)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayers(model: RotatableDialKeyboardModel) {
        for layerModel in model.languages {
            var layers: [RotatableDialKeyboardLayer] = []
            for slice in layerModel.value {
                let layer = RotatableDialKeyboardLayer(slice)
                
                configureButtons(buttons: slice.keys, for: layer)
                
                layers.append(layer)
            }
            
            alphabets[layerModel.key] = layers
        }
        
        guard let layers = alphabets[model.languagesSequence[0]] else { return }
        configureCurrentLanguage(alphabet: model.languagesSequence[0], layers: layers)
    }
    
    private func configureCurrentLanguage(alphabet: String, layers: [RotatableDialKeyboardLayer]) {
        for layer in layers {
            addSubview(layer)
            layer.pinCenter(to: self)
            
            for buttonNumber in 0..<layer.buttons.count {
                layer.addSubview(layer.buttons[buttonNumber])
                setupButtonPosition(
                    button: layer.buttons[buttonNumber],
                    degrees: layer.model?.degrees ?? 0,
                    radius: layer.model?.distanceCenterToButtonCenter ?? 0,
                    buttonNumber: UInt32(buttonNumber)
                )
            }
        }
        currentAlphabet = alphabet
    }
    
    private func configureButtons(
        buttons: [RotatableDialKeyboardModel.DialKey],
        for layer: RotatableDialKeyboardLayer
    ) {
        var button: RotatableDialKeyboardButton
        for buttonNumber in 0..<buttons.count {
            button = RotatableDialKeyboardButton(buttons[buttonNumber])
            
            button.shiftDelegate = self
            button.changingAlphabetsDelegate = self
            
            layer.buttons.append(button)
        }
    }
    
    private func setupButtonPosition(
        button: RotatableDialKeyboardButton,
        degrees: CGFloat,
        radius: CGFloat,
        buttonNumber: UInt32
    ) {
        let horizontalOffset = radius * cos(CGFloat(buttonNumber) * degrees * .pi / 180)
        let verticalOffset = radius * sin(CGFloat(buttonNumber) * degrees * .pi / 180)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(
            equalTo: centerXAnchor,
            constant: horizontalOffset
        ).isActive = true
        button.centerYAnchor.constraint(
            equalTo: centerYAnchor,
            constant: verticalOffset
        ).isActive = true
    }
    
    private func rotateLayer(rotatingLayer: RotatableDialKeyboardLayer, touch: UITouch) {
        let rotationAngle = atan2(
            rotatingLayer.center.y - touch.location(in: self).y,
            rotatingLayer.center.x - touch.location(in: self).x
        )
        
        rotatingLayer.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        rotatingLayer.buttons.forEach { button in
            button.transform = CGAffineTransform(rotationAngle: -rotationAngle)
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        guard let isRotating = model?.isRotating else { return }
        if (isRotating) {
            guard let layers = alphabets[currentAlphabet] else { return }
            rotateLayers(touch: touch, layers: layers)
        }
    }
    
    private func rotateLayers(touch: UITouch, layers: [RotatableDialKeyboardLayer]) {
        guard let lastLayer = layers.last else {
            return
        }
        
        let area = pow(touch.location(in: self).y - lastLayer.center.y, 2) + pow(touch.location(in: self).x - lastLayer.center.x, 2)
        
        for i in stride(from: layers.count-1, through: 0, by: -1) {
            guard let layerHeight = layers[i].model?.height else { return }
            if area <= pow(CGFloat(layerHeight) / 2, 2) {
                rotateLayer(rotatingLayer: layers[i], touch: touch)
                break
            }
        }
    }
    
    private func rotateLayersBack(layers: [RotatableDialKeyboardLayer]) {
        layers.forEach { layer in
            UIView.animate(withDuration: 2) {
                layer.transform = .identity
                
                layer.buttons.forEach { button in
                    button.transform = .identity
                }
            }
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let isRotating = model?.isRotating else { return }
        if isRotating {
            guard let layers = alphabets[currentAlphabet] else { return }
            rotateLayersBack(layers: layers)
        }
    }
}

extension RotatableDialKeyboard: KeyboardShiftDelegate {
    public func shiftKeyWasTapped() {
        guard let layers = alphabets[currentAlphabet] else { return }
        
        for layer in layers {
            if (layer.model?.shiftedKeys != nil) {
                for buttonNumber in 0..<layer.buttons.count {
                    guard let title = layer.model?.shiftedKeys?[buttonNumber] else { return }
                    
                    if (layer.buttons[buttonNumber].button.titleLabel?.text == title) {
                        layer.buttons[buttonNumber].button.setTitle(
                            layer.buttons[buttonNumber].model?.content,
                            for: .normal
                        )
                    } else {
                        layer.buttons[buttonNumber].button.setTitle(title, for: .normal)
                    }
                }
            }
        }
    }
}

extension RotatableDialKeyboard: KeyboardChangingAlphabetsDelegate {
    public func changeAlphabetsKeyWasTapped() {
        guard let currentLayers = alphabets[currentAlphabet] else { return }
        guard let languagesSequence = model?.languagesSequence else { return }
        
        for languageNumber in 0..<languagesSequence.count {
            if (languagesSequence[languageNumber] == currentAlphabet) {
                let language = languageNumber + 1 == languagesSequence.count
                    ? languagesSequence[0]
                    : languagesSequence[languageNumber + 1]
                changeAlphabets(currentAlphabets: currentLayers, language: language)
                
                return
            }
        }
    }
    
    private func changeAlphabets(
        currentAlphabets: [RotatableDialKeyboardLayer],
        language: String
    ) {
        guard let newLayers = alphabets[language] else { return }
        
        for layer in currentAlphabets as [UIView] {
            layer.removeFromSuperview()
        }
        
        for layer in newLayers {
            addSubview(layer)
            layer.pinCenter(to: self)
            
            for buttonNumber in 0..<layer.buttons.count {
                layer.addSubview(layer.buttons[buttonNumber])
                setupButtonPosition(
                    button: layer.buttons[buttonNumber],
                    degrees: layer.model?.degrees ?? 0,
                    radius: layer.model?.distanceCenterToButtonCenter ?? 0,
                    buttonNumber: UInt32(buttonNumber)
                )
            }
        }
        
        currentAlphabet = language
    }
}

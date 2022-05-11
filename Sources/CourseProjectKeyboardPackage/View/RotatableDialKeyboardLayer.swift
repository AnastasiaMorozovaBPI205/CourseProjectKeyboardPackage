//
//  KeyboardLayer.swift
//
//
//  Created by Anastasia on 22.03.2022.
//

import UIKit

public final class RotatableDialKeyboardLayer: UIView {
    var model: RotatableDialKeyboardModel.DialSlice?
    var buttons: [RotatableDialKeyboardButton] = []
    
    public init(_ model: RotatableDialKeyboardModel.DialSlice) {
        super.init(frame: .zero)
        
        self.model = model
        configureLayer()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayer() {
        guard let model = model else { return }
        
        setHeight(to: model.height)
        pinWidth(to: heightAnchor)
        
        if (model.layerColor != nil) {
            backgroundColor = model.layerColor
        } else {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [
                model.layerGradient?.colorTop ?? UIColor.clear,
                model.layerGradient?.colorBottom ?? UIColor.clear
            ]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.frame = CGRect(
                x: 0,
                y: 0,
                width: model.height,
                height: model.height
            )
            
            layer.insertSublayer(gradientLayer, at: 0)
            layer.cornerRadius = CGFloat(model.height / 2)
            clipsToBounds = true
        }
        
        if (
            model.shadowColor != nil &&
                model.shadowOffset != nil &&
                model.shadowOpacity != nil
        ) {
            configureLayerShadow(
                shadowColor: model.shadowColor,
                shadowOffset: model.shadowOffset,
                shadowOpacity: model.shadowOpacity
            )
        }
    }
    
    private func configureLayerShadow(
        shadowColor: CGColor?,
        shadowOffset: CGSize?,
        shadowOpacity: Float?
    ) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset ?? CGSize()
        layer.shadowOpacity = shadowOpacity ?? 0
        layer.shadowRadius = 0.0
        layer.masksToBounds = false
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        //        let view = super.hitTest(point, with: event)
        //        return view == self ? nil : view
        
        
        for subview in buttons {
            if (subview.point(inside: convert(point, to: subview), with: event)){
                return subview
            }
        }
        return nil
    }
}


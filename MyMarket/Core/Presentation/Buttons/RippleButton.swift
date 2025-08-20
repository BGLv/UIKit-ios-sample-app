//
//  RippleButton.swift
//  MyMarket
//
//  Created by Bohdan Huk on 20.08.2025.
//

import UIKit

class RippleButton: UIButton {
    private var rippleLayer: CAShapeLayer?
    private var isTouching = false
    private var isHolding = false
    private var isRefreshing = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        clipsToBounds = true
        addTarget(self, action: #selector(buttonTouchedUp(_:)), for: [.touchUpInside, .touchUpOutside])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isTouching = true
        if rippleLayer != nil {
            rippleLayer?.removeFromSuperlayer()
            rippleLayer?.removeAllAnimations()
            rippleLayer = nil
            isRefreshing = true
        }
        // Get the location of the touch in the button’s coordinate system
        if let touch = touches.first {
            let location = touch.location(in: self)
            createRippleEffect(at: location)
        }
    }
    
    @objc private func buttonTouchedUp(_ sender: UIButton) {
        isTouching = false
        guard isHolding else {
            isHolding = false
            return
        }
        animateRemoveRippleLayer()
        isHolding = false
    }
    
    private func createRippleEffect(at point: CGPoint) {
        let diameter = bounds.width * 2
        let path = UIBezierPath(ovalIn: CGRect(x: -diameter / 2, y: -diameter / 2, width: diameter, height: diameter))
        let rippleLayer = CAShapeLayer()
        rippleLayer.path = path.cgPath
        rippleLayer.position = point
        rippleLayer.fillColor = UIColor.black.cgColor
        rippleLayer.opacity = 0.2
        layer.addSublayer(rippleLayer)
        self.rippleLayer = rippleLayer
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.1
        animation.toValue = 1
        animation.duration = 0.5
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.isRemovedOnCompletion = true
        rippleLayer.add(animation, forKey: "rippleEffect")
    }
    
    private func animateRemoveRippleLayer() {
        UIView.transition(with: self,
                          duration: 0.3,
                          options: [.allowUserInteraction, .transitionCrossDissolve]) {
            guard !self.isRefreshing else {
                self.isRefreshing = false
                return
            }
            self.rippleLayer?.removeFromSuperlayer()
            self.rippleLayer?.removeAllAnimations()
            self.rippleLayer = nil
            self.isRefreshing = false
        }
    }
}

extension RippleButton: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard !isTouching else {
            isHolding = true
            return
        }
        animateRemoveRippleLayer()
        isHolding = false
    }
}

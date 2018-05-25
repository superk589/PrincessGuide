//
//  ErrorView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class ErrorView: UIView {

    var dashOneLayer = ErrorView.generateDashLayer()
    var dashTwoLayer = ErrorView.generateDashLayer()
    
    class func generateDashLayer() -> CAShapeLayer {
        let dash = CAShapeLayer()
        dash.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        dash.path = {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: 25))
            path.addLine(to: CGPoint(x: 50, y: 25))
            return path.cgPath
        }()
        dash.lineCap = kCALineCapRound
        dash.lineJoin = kCALineJoinRound
        dash.fillColor = nil
        dash.lineWidth = 6
        dash.fillMode = kCAFillModeForwards
        return dash
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(dashOneLayer)
        layer.addSublayer(dashTwoLayer)
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            themable.dashOneLayer.strokeColor = theme.color.tint.cgColor
            themable.dashTwoLayer.strokeColor = theme.color.tint.cgColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotationAnimation(_ angle: CGFloat) -> CABasicAnimation {
        var animation: CABasicAnimation
        let springAnimation = CASpringAnimation(keyPath:"transform.rotation.z")
        springAnimation.damping = 1.5
        springAnimation.mass = 0.22
        springAnimation.initialVelocity = 0.5
        animation = springAnimation
        
        animation.fromValue = 0.0
        animation.toValue = angle * CGFloat(.pi / 180.0)
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return animation
    }
    
    public func startAnimation() {
        let dashOneAnimation = rotationAnimation(-45.0)
        let dashTwoAnimation = rotationAnimation(45.0)
        
        dashOneLayer.transform = CATransform3DMakeRotation(-45 * CGFloat(.pi / 180.0), 0.0, 0.0, 1.0)
        dashTwoLayer.transform = CATransform3DMakeRotation(45 * CGFloat(.pi / 180.0), 0.0, 0.0, 1.0)
        
        dashOneLayer.add(dashOneAnimation, forKey: "dashOneAnimation")
        dashTwoLayer.add(dashTwoAnimation, forKey: "dashTwoAnimation")
    }
    
    public func stopAnimation() {
        dashOneLayer.removeAnimation(forKey: "dashOneAnimation")
        dashTwoLayer.removeAnimation(forKey: "dashTwoAnimation")
    }

}

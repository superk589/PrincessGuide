//
//  CompletionView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class CompletionView: UIView {
    
    var checkmarkShapeLayer: CAShapeLayer = {
        let checkmarkPath = UIBezierPath()
        checkmarkPath.move(to: CGPoint(x: 0, y: 25))
        checkmarkPath.addLine(to: CGPoint(x: 19, y: 50))
        checkmarkPath.addLine(to: CGPoint(x: 50, y: 0))
        
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        layer.path = checkmarkPath.cgPath
        layer.fillMode = .forwards
        layer.lineCap = .round
        layer.lineJoin = .round
        layer.fillColor = nil
        layer.strokeColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0).cgColor
        layer.lineWidth = 6.0
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(checkmarkShapeLayer)
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.checkmarkShapeLayer.strokeColor = theme.color.tint.cgColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        let checkmarkStrokeAnimation = CAKeyframeAnimation(keyPath:"strokeEnd")
        checkmarkStrokeAnimation.values = [0, 1]
        checkmarkStrokeAnimation.keyTimes = [0, 1]
        checkmarkStrokeAnimation.duration = 0.35
        checkmarkShapeLayer.add(checkmarkStrokeAnimation, forKey:"stroke")
    }
    
    func stopAnimation() {
        checkmarkShapeLayer.removeAnimation(forKey: "stroke")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 50, height: 50)
    }

}

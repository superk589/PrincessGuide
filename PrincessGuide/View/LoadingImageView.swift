//
//  LoadingImageView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class LoadingImageView: UIView {
    
    let star1 = UIImageView(image: #imageLiteral(resourceName: "loading_star").withRenderingMode(.alwaysTemplate))
    let star2 = UIImageView(image: #imageLiteral(resourceName: "loading_star").withRenderingMode(.alwaysTemplate))

    var isRotating = false
    var hideWhenStopped = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        star1.tintColor = .hatsuneYellow
        star2.tintColor = .hatsunePurple
        
        addSubview(star1)
        addSubview(star2)
        
        star1.snp.makeConstraints { (make) in
            make.width.height.equalTo(snp.width).multipliedBy(0.7)
            make.top.right.equalToSuperview()
        }
        
        star2.snp.makeConstraints { (make) in
            make.width.height.equalTo(snp.width).multipliedBy(0.4)
            make.bottom.left.equalToSuperview()
        }
        
        startAnimating()
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createAnimtion(fromValue: CGFloat, toValue: CGFloat, offset: CFTimeInterval) -> CABasicAnimation {
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fromValue = fromValue
        rotate.toValue = toValue
        rotate.timeOffset = offset
        rotate.duration = 2
        rotate.repeatCount = .infinity
        // make the animation not removed when the application returns to active
        rotate.isRemovedOnCompletion = false
        return rotate
    }
    
    func startAnimating() {
        star1.layer.add(createAnimtion(fromValue: 0, toValue: 2.0 * .pi, offset: 0.17), forKey: "rotate")
        star2.layer.add(createAnimtion(fromValue: 2.0 * .pi, toValue: 0, offset: 0.5), forKey: "rotate")
        isRotating = true
        isHidden = false
    }
    
    func stopAnimating() {
        if hideWhenStopped {
            isHidden = true
        }
        star1.layer.removeAnimation(forKey: "rotate")
        star2.layer.removeAnimation(forKey: "rotate")
        isRotating = false
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func show(to view: UIView) {
        view.addSubview(self)
        snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        startAnimating()
    }
    
    func hide() {
        removeFromSuperview()
    }

}

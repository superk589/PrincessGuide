//
//  FixedTabBar.swift
//  PrincessGuide
//
//  Created by zzk on 2018/11/10.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class FixedTabBar: UITabBar {
    
    var buttonFrames: [CGRect] = []
    var size: CGSize = .zero
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if UIDevice.current.systemVersion >= "12.1" {
            let buttons = subviews.filter {
                String(describing: type(of: $0)).hasSuffix("Button")
            }
            if buttonFrames.count == buttons.count, size == bounds.size {
                zip(buttons, buttonFrames).forEach { $0.0.frame = $0.1 }
            } else {
                buttonFrames = buttons.map { $0.frame }
                size = bounds.size
            }
        }
    }
}

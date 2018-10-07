//
//  StrokedLabel.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/12.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class StrokedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        
        let offset = shadowOffset
        let color = textColor
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2)
        context?.setLineJoin(.round)
        
        context?.setTextDrawingMode(.stroke)
        textColor = .white
        super.drawText(in: rect)
        
        context?.setTextDrawingMode(.fill)
        textColor = color
        shadowOffset = CGSize(width: 0, height: 0)
        super.drawText(in: rect)
        
        shadowOffset = offset
    }
}

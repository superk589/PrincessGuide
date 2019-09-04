//
//  StrokedTextLabel.swift
//  PrincessGuide
//
//  Created by zzk on 9/4/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import UIKit

class StrokedTextLabel: UILabel {
    
    var strokeColor: UIColor = .white
        
    override func drawText(in rect: CGRect) {
        
        let offset = shadowOffset
        let color = textColor
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setLineWidth(2)
        ctx?.setLineJoin(.round)
        
        ctx?.setTextDrawingMode(.stroke)
        textColor = strokeColor
        super.drawText(in: rect)
        
        ctx?.setTextDrawingMode(.fill)
        textColor = color
        shadowOffset = CGSize(width: 0, height: 0)
        super.drawText(in: rect)
        
        shadowOffset = offset
    }
}

//
//  UIImage+Background.swift
//  PrincessGuide
//
//  Created by zzk on 8/10/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import UIKit

extension UIImage {

    func addBackground(_ color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let path = UIBezierPath(rect: bounds)
        color.setFill()
        path.fill()
        draw(in: bounds)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

}

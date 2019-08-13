//
//  UIImage+Background.swift
//  PrincessGuide
//
//  Created by zzk on 8/10/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import UIKit

extension UIImage {

    func addBackground(_ image: UIImage) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        image.draw(in: bounds)
        draw(in: bounds)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

}

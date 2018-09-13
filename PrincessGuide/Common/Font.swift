//
//  Font.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

extension UIFont {

    static func scaledFont(forTextStyle textStyle: UIFont.TextStyle, ofSize size: CGFloat) -> UIFont {
        if #available(iOS 11.0, *) {
            return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: UIFont.preferredFont(forTextStyle: textStyle).withSize(size))
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
}

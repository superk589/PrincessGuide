//
//  UIApplication+KeyWindow.swift
//  PrincessGuide
//
//  Created by zzk on 9/11/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import UIKit

extension UIApplication {
    
    /// Use this to replace UIApplication.shared.keyWindow
    var currentWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    }
    
}

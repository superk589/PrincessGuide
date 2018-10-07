//
//  ArrayExtension.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/8.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

extension Array {
    
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
    
}

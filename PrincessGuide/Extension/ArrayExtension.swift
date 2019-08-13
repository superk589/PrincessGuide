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

extension Array where Element == NSAttributedString {
    
    func joined(separator: String = "") -> NSAttributedString {
        let result = NSMutableAttributedString()
        var iter = makeIterator()
        if let first = iter.next() {
            result.append(first)
            while let next = iter.next() {
                result.append(NSAttributedString(string: separator))
                result.append(next)
            }
        }
        return result
    }
}

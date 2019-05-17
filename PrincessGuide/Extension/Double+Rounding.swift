//
//  Double+Rounding.swift
//  PrincessGuide
//
//  Created by zzk on 2019/5/17.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation

extension Double {
    
    func roundedString(roundingRule: FloatingPointRoundingRule?) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ""
        if let roundingRule = roundingRule {
            formatter.maximumFractionDigits = 0
            formatter.roundingMode = NumberFormatter.RoundingMode(floatingPointRoundingRule: roundingRule)
        }
        return formatter.string(for: self)!
    }
    
}

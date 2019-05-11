//
//  Decimal+Rounding.swift
//  PrincessGuide
//
//  Created by zzk on 2019/5/11.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation

extension NumberFormatter.RoundingMode {
    
    init(floatingPointRoundingRule: FloatingPointRoundingRule) {
        switch floatingPointRoundingRule {
        case .toNearestOrAwayFromZero:
            self = .halfUp
        case .toNearestOrEven:
            self = .halfEven
        case .up:
            self = .ceiling
        case .down:
            self = .floor
        case .towardZero:
            self = .down
        case .awayFromZero:
            self = .up
        @unknown default:
            fatalError("unknown rounding rule")
        }
    }
}

extension Decimal {

    func roundedBy(roundingRule: FloatingPointRoundingRule?) -> Decimal {
        return Decimal(string: roundedString(roundingRule: roundingRule))!
    }
    
    func roundedString(roundingRule: FloatingPointRoundingRule?) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ""
        if let roundingRule = roundingRule {
            formatter.maximumFractionDigits = 0
            formatter.roundingMode = NumberFormatter.RoundingMode(floatingPointRoundingRule: roundingRule)
        }
        return formatter.string(from: self as NSDecimalNumber)!
    }

}

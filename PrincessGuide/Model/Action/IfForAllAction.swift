//
//  IfForAllAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class IfForAllAction: ActionParameter {
    
//    enum IFType: Int {
//        case stop = 100
//        case blind = 200
//        case convert = 300
//        case decoy = 400
//        case burn = 500
//        case targetHP = 900
//        case defeat = 1000
//        case skillCount = 1200
//    }
    
    override func localizedDetail(of level: Int) -> String {
        
        switch actionDetail1 {
        case 0..<100:
            if actionDetail2 != 0 && actionDetail3 != 0 {
                let format = NSLocalizedString("Random event: %d%% chance use %d, otherwise %d.", comment: "")
                return String(format: format, actionDetail1, actionDetail2 % 10, actionDetail3 % 10)
            } else if actionDetail2 != 0 {
                let format = NSLocalizedString("Random event: %d%% chance use %d.", comment: "")
                return String(format: format, actionDetail1, actionDetail2 % 10)
            } else {
                return super.localizedDetail(of: level)
            }
        case 1000:
            let format = NSLocalizedString("Condition: if defeat target by the last effect then use %d.", comment: "")
            return String(format: format, actionDetail2 % 10)
        case 1200..<1300:
            if actionDetail2 != 0 && actionDetail3 != 0 {
                let format = NSLocalizedString("Condition: counter is greater or equal to %d then use %d, otherwise %d.", comment: "")
                return String(format: format, actionDetail1 % 10, actionDetail2 % 10, actionDetail3 % 10)
            } else if actionDetail2 != 0 {
                let format = NSLocalizedString("Condition: counter is greater or equal to %d then use %d.", comment: "")
                return String(format: format, actionDetail1 % 10, actionDetail2 % 10)
            } else {
                return super.localizedDetail(of: level)
            }
        default:
            return super.localizedDetail(of: level)
        }
    }
    
}

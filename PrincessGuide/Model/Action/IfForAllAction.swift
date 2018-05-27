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
            if actionDetail2 < actionDetail3 {
                let format = NSLocalizedString("Random event: %d%% chance.", comment: "")
                return String(format: format, actionDetail1)
            } else {
                let format = NSLocalizedString("Random event: %d%% chance.", comment: "")
                return String(format: format, 100 - actionDetail1)
            }
        case 1000:
            return NSLocalizedString("Condition: defeat target by the last effect.", comment: "")
        case 1200..<1300:
            if actionDetail2 < actionDetail3 {
                let format = NSLocalizedString("Condition: counter is greater or equal to %d.", comment: "")
                return String(format: format, actionDetail1 % 10)
            } else {
                let format = NSLocalizedString("Condition: counter is less than %d.", comment: "")
                return String(format: format, actionDetail1 % 10)
            }
        default:
            return super.localizedDetail(of: level)
        }
    }
    
}

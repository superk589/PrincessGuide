//
//  SummonAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class SummonAction: ActionParameter {

    override func localizedDetail(of level: Int) -> String {
        let format = NSLocalizedString("Summon minion, ID: %d.", comment: "")
        return String(format: format, actionDetail2)
    }
    
}

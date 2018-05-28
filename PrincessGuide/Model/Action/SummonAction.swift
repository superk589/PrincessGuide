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
        let format = NSLocalizedString("Summon a minion of ID: %d at the position of %@.", comment: "")
        return String(format: format, actionDetail2, targetParameter.buildTargetClause())
    }
    
}

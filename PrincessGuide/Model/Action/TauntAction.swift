//
//  TauntAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class TauntAction: ActionParameter {
    
    override func localizedDetail(of level: Int) -> String {
        let format = NSLocalizedString("Taunt all enemy targets for %@s.", comment: "")
        return String(format: format, actionValue1.description)
    }
}

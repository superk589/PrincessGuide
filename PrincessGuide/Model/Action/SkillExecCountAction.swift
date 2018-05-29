//
//  SkillExecCountAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class SkillExecCountAction: ActionParameter {
    
    override func localizedDetail(of level: Int, property: Property = .zero) -> String {
        let format = NSLocalizedString("Add [%d] to the counter.", comment: "")
        return String(format: format, Int(actionValue1))
    }
}

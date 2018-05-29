//
//  ChangePatternAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class ChangePatterAction: ActionParameter {
    
    
    override func localizedDetail(of level: Int, property: Property = .zero) -> String {
        switch actionDetail1 {
        case 1:
            return NSLocalizedString("Change attack pattern.", comment: "")
        default:
            return super.localizedDetail(of: level)
        }
    }
}

//
//  AdditiveAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class AdditiveAction: GiveValueAction {
    
    override var format: String {
        return NSLocalizedString("Modifier: add %@ to value %d of effect %d.", comment: "")
    }
}

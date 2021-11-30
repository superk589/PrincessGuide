//
//  GiveValueAsDivideAction.swift
//  PrincessGuide
//
//  Created by Zhenkai Zhao on 2021/11/30.
//  Copyright © 2021 zzk. All rights reserved.
//

import Foundation

class GiveValueAsDivideAction: GiveValueAction {
    
    override var format: String {
        return NSLocalizedString("Modifier: divide %@ to value %d of effect %d.", comment: "")
    }
    
}

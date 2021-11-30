//
//  MultipleAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class MultipleAction: GiveValueAction {
    
    override var format: String {
        return NSLocalizedString("Modifier: multiple %@ to value %d of effect %d.", comment: "")
    }
    
}

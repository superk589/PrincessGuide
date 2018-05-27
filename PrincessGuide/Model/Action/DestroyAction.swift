//
//  DestroyAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class DestroyAction: ActionParameter {
    
    override func localizedDetail(of level: Int) -> String {
        return NSLocalizedString("Die instantly.", comment: "")
    }
    
}

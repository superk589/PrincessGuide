//
//  MoveAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class MoveAction: ActionParameter {
    
    override func localizedDetail(of level: Int) -> String {
        let format = NSLocalizedString("Change self position.", comment: "")
        return String(format: format)
    }
    
}

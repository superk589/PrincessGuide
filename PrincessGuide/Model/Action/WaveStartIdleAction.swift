//
//  WaveStartIdleAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class WaveStartIdleAction: ActionParameter {
    
    override func localizedDetail(of level: Int) -> String {
        let format = NSLocalizedString("Appear after %@s since wave start.", comment: "")
        return String(format: format, actionValue1.description)
    }
}

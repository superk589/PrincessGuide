//
//  HatsuneEventSpecialBattle.swift
//  PrincessGuide
//
//  Created by zzk on 2018/12/31.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class HatsuneEventSpecialBattle: Codable {
    
    let waveGroupId: Int
    let mode: Int
    
    func preload() {
        _ = wave
    }
    
    lazy var wave: Wave? = DispatchSemaphore.sync { (closure) in
        Master.shared.getWaves(waveIDs: [waveGroupId], callback: closure)
    }?.first
}

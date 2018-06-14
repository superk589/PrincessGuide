//
//  Dungeon.swift
//  PrincessGuide
//
//  Created by zzk on 2018/6/14.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class Dungeon: Codable {
    let waveGroupId: Int
    let dungeonAreaId: Int
    let dungeonName: String
    
    init(waveGroupId: Int, dungeonAreaId: Int, dungeonName: String) {
        self.waveGroupId = waveGroupId
        self.dungeonAreaId = dungeonAreaId
        self.dungeonName = dungeonName
    }
    
    lazy var wave: Wave? = DispatchSemaphore.sync { (closure) in
        Master.shared.getWaves(waveIDs: [waveGroupId], callback: closure)
    }?.first
}

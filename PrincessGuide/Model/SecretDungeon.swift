//
//  SecretDungeon.swift
//  PrincessGuide
//
//  Created by zzk on 2022/5/15.
//  Copyright © 2022 zzk. All rights reserved.
//

import Foundation

class SecretDungeon: Codable {
    
    let dungeonAreaId: Int
    let startTime: Date
    
    init(dungeonAreaId: Int, startTime: Date) {
        self.dungeonAreaId = dungeonAreaId
        self.startTime = startTime
    }

    lazy var floors: [SecretFloor] = DispatchSemaphore.sync { closure in
        Master.shared.getSecretFloors(dungeonID: dungeonAreaId, callback: closure)
    } ?? []
    
    var name: String {
        return String(format: NSLocalizedString("Secret Dungeon %d-%d", comment: ""), startTime.year, startTime.month)
    }
}

class SecretFloor: Codable {
    let difficulty: Int
    let waveGroupId: Int
    let questId: Int
    let floorNum: Int
    
    lazy var wave: Wave? = DispatchSemaphore.sync { closure in
        Master.shared.getWaves(waveIDs: [waveGroupId], callback: closure)
    }?.first
}

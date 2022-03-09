//
//  Dungeon.swift
//  PrincessGuide
//
//  Created by zzk on 2018/6/14.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

protocol Dungeon {
    var dungeonAreaId: Int { get }
    var dungeonName: String { get }
    var waves: [Wave] { get }
}

class NormalDungeon: Dungeon, Codable {
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
    
    var waves: [Wave] {
        [wave].compactMap { $0 }
    }
}

class SpecialDungeon: Dungeon, Codable {
    
    let waveGroupIds: String
    let dungeonAreaId: Int
    let dungeonName: String
    
    init(waveGroupIds: String, dungeonAreaId: Int, dungeonName: String) {
        self.waveGroupIds = waveGroupIds
        self.dungeonAreaId = dungeonAreaId
        self.dungeonName = dungeonName
    }
    
    lazy var waves: [Wave] = DispatchSemaphore.sync { (closure) in
        Master.shared.getWaves(waveIDs: Array(waveGroupIds.split(separator: ",")).compactMap { Int($0) }, callback: closure)
    } ?? []
    
}

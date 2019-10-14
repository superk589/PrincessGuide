//
//  TowerCloister.swift
//  PrincessGuide
//
//  Created by zzk on 10/14/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation

class TowerCloister: NSObject {
    
    class Wave: Codable {
        
        lazy var enemies: [Enemy] = self.enemyIDs.flatMap { enemyID in
            return DispatchSemaphore.sync { (closure) in
                Master.shared.getTowerEnemies(enemyID: enemyID, callback: closure)
                } ?? []
        }
        
        var enemyIDs: [Int] {
            return [enemyId1, enemyId2, enemyId3, enemyId4, enemyId5]
        }
        
        let enemyId1: Int
        let enemyId2: Int
        let enemyId3: Int
        let enemyId4: Int
        let enemyId5: Int
        
    }
    
    let base: Base
    
    lazy var waves: [Wave] = DispatchSemaphore.sync { closure in
        Master.shared.getTowerCloisterWaves(waveIDs: [self.base.waveGroupId1, self.base.waveGroupId2, self.base.waveGroupId3], callback: closure)
    } ?? []
    
    init(base: Base) {
        self.base = base
    }
    
    struct Base: Codable {
        let towerCloisterQuestId: Int
        let dailyLimit: Int
        let limitTime: Int
        let recoveryHpRate: Int
        let recoveryTpRate: Int
        let startTpRate: Int
        let fixRewardGroupId: Int
        let dropRewardGroupId: Int
        let background1: Int
        let waveGroupId1: Int
        let background2: Int
        let waveGroupId2: Int
        let background3: Int
        let waveGroupId3: Int
        let waveBgm: String
        let rewardImage1: Int
        let rewardImage2: Int
        let rewardImage3: Int
        let rewardImage4: Int
        let rewardImage5: Int
        let background: Int
        let bgPosition: Int
    }
}

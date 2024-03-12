//
//  TalentQuest.swift
//  PrincessGuide
//
//  Created by zzk on 2024/3/12.
//  Copyright © 2024 zzk. All rights reserved.
//

import Foundation

class TalentQuest: Codable {
    
    class Wave: Codable {
        
        lazy var enemies: [Enemy] = self.enemyIDs.flatMap { enemyID in
            return DispatchSemaphore.sync { (closure) in
                Master.shared.getTalentEnemies(enemyID: enemyID, callback: closure)
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
    
    let questName: String
    let waveGroupId1: Int
        
    lazy var wave: Wave? = DispatchSemaphore.sync { closure in
        Master.shared.getTalentWaves(waveIDs: [self.waveGroupId1], callback: closure)
    }?.first
}

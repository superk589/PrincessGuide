//
//  Tower.swift
//  PrincessGuide
//
//  Created by zzk on 2018/9/13.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class Tower: Codable {

    let towerAreaId: Int
    let maxFloorNum: Int
    
    var name: String {
        
        let format = NSLocalizedString("Luna's Tower %d", comment: "")
        return String(format: format, towerAreaId)
    }
    
    lazy var quests: [Quest] = DispatchSemaphore.sync { (closure) in
        Master.shared.getTowerQuests(towerID: towerAreaId, callback: closure)
    } ?? []
    
    lazy var exQuests: [Quest] = DispatchSemaphore.sync { (closure) in
        Master.shared.getTowerExQuests(towerID: towerAreaId, callback: closure)
    } ?? []
    
    func preload() {
        quests.forEach {
            _ = $0.enemies
        }
        exQuests.forEach {
            _ = $0.enemies
        }
    }
    
    class Quest: Codable {
    
        lazy var enemies: [Enemy] = self.enemyIDs.flatMap { enemyID in
            return DispatchSemaphore.sync { (closure) in
                Master.shared.getTowerEnemies(enemyID: enemyID, callback: closure)
                } ?? []
        }
        
        var enemyIDs: [Int] {
            return [enemyId1, enemyId2, enemyId3, enemyId4, enemyId5]
        }
        
        let odds: Int?
        let enemyId1: Int
        let enemyId2: Int
        let enemyId3: Int
        let enemyId4: Int
        let enemyId5: Int

        let background: Int
        let fixRewardGroupId: Int
        let floorNum: Int
        let limitTime: Int
        let rewardCount1: Int
        let rewardCount2: Int
        let rewardCount3: Int
        let rewardCount4: Int
        let rewardCount5: Int
        let rewardImage1: Int
        let rewardImage2: Int
        let rewardImage3: Int
        let rewardImage4: Int
        let rewardImage5: Int
        let stamina: Int
        let staminaStart: Int
        let teamExp: Int
        let towerAreaId: Int
        let towerQuestId: Int?
        let towerExQuestId: Int?
        let waveGroupId: Int
    }

}

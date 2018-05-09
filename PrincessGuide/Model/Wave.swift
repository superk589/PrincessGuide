//
//  Wave.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class Wave: Codable {
    
    let base: Base
    let drops: [Drop]
    
    var enemies: [EnemyUnit] {
        return base.units
    }
    
    init(base: Base, drops: [Drop]) {
        self.base = base
        self.drops = drops
    }
    
    class Base: Codable {
        let units: [EnemyUnit]
        let id: Int
        let odds: Int
        let waveGroupId: Int
        init(units: [EnemyUnit], id: Int, odds: Int, waveGroupId: Int) {
            self.units = units
            self.id = id
            self.odds = odds
            self.waveGroupId = waveGroupId
        }
    }
    
    class EnemyUnit: Codable {
        let dropGold: Int
        let dropRewardID: Int
        let enemyID: Int
        
        init(dropGold: Int, dropRewardID: Int, enemyID: Int) {
            self.dropGold = dropGold
            self.dropRewardID = dropRewardID
            self.enemyID = enemyID
        }
        lazy var enemy: Enemy? = DispatchSemaphore.sync { (closure) in
            Master.shared.getEnemies(enemyID: enemyID, callback: closure)
        }?.first
    }
    
}

//
//  Wave.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

struct Wave: Codable {
    
    let base: Base
    let dropRewards: [DropReward]
    
    init(base: Base, dropRewards: [DropReward]) {
        self.base = base
        self.dropRewards = dropRewards
    }
    
    struct Base: Codable {
        let dropGold1: Int
        let dropGold2: Int
        let dropGold3: Int
        let dropGold4: Int
        let dropGold5: Int
        let dropRewardId1: Int
        let dropRewardId2: Int
        let dropRewardId3: Int
        let dropRewardId4: Int
        let dropRewardId5: Int
        let enemyId1: Int
        let enemyId2: Int
        let enemyId3: Int
        let enemyId4: Int
        let enemyId5: Int
        let id: Int
        let odds: Int
        let waveGroupId: Int
    }
    
}

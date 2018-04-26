//
//  Quest.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class Quest: Codable {

    let base: Base
    
    let waves: [Wave]
    
    init(base: Base, waves: [Wave]) {
        self.base = base
        self.waves = waves
    }
    
    struct Base: Codable {
        
        let areaId: Int
        let background1: Int
        let background2: Int
        let background3: Int
        let clearRewardGroup: Int
        let dailyLimit: Int
        let endTime: String
        let enemyImage1: Int
        let enemyImage2: Int
        let enemyImage3: Int
        let enemyImage4: Int
        let enemyImage5: Int
        let iconId: Int
        let limitTeamLevel: Int
        let limitTime: Int
        let love: Int
        let positionX: Int
        let positionY: Int
        let questDetailBgId: Int
        let questDetailBgPosition: Int
        let questId: Int
        let questName: String
        let rankRewardGroup: Int
        let rewardImage1: Int
        let rewardImage2: Int
        let rewardImage3: Int
        let rewardImage4: Int
        let rewardImage5: Int
        let stamina: Int
        let staminaStart: Int
        let startTime: String
        let storyIdWaveend1: Int
        let storyIdWaveend2: Int
        let storyIdWaveend3: Int
        let storyIdWavestart1: Int
        let storyIdWavestart2: Int
        let storyIdWavestart3: Int
        let teamExp: Int
        let unitExp: Int
        let waveBgmQueId1: String
        let waveBgmQueId2: String
        let waveBgmQueId3: String
        let waveBgmSheetId1: String
        let waveBgmSheetId2: String
        let waveBgmSheetId3: String
        let waveGroupId1: Int
        let waveGroupId2: Int
        let waveGroupId3: Int

    }
    
}

extension Quest {

    var allRewards: [Drop.Reward] {
        return waves.flatMap { $0.drops.flatMap { $0.rewards } }
    }
}

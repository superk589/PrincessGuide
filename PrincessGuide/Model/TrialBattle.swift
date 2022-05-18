//
//  TrialBattle.swift
//  PrincessGuide
//
//  Created by zzk on 2022/5/18.
//  Copyright © 2022 zzk. All rights reserved.
//

import Foundation

class TrialQuest: Codable {
    
    let categoryId: Int
    let categoryName: String
    let description: String
    
    init(categoryId: Int, categoryName: String, description: String) {
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.description = description
    }
    
    lazy var battles: [TrialBattle] = DispatchSemaphore.sync { closure in
        Master.shared.getTrialBattles(categoryID: categoryId, callback: closure)
    } ?? []
}

class TrialBattle: Codable {
    let difficulty: Int
    let waveGroupId: Int
    let battleName: String
    
    lazy var wave: Wave? = DispatchSemaphore.sync { closure in
        Master.shared.getWaves(waveIDs: [waveGroupId], callback: closure)
    }?.first
}

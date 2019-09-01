//
//  Rarity6UnlockQuest.swift
//  PrincessGuide
//
//  Created by zzk on 9/1/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation

class Rarity6UnlockQuest: Codable {

    let unitId: Int
    let questName: String
    let waveGroupId: Int
    
    lazy var card: Card? = Preload.default.cards[self.unitId]
    
    lazy var wave: Wave? = DispatchSemaphore.sync { closure in
        Master.shared.getWaves(waveIDs: [self.waveGroupId], callback: closure)
    }?.first
    
}

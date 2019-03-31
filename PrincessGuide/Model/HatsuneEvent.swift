//
//  HatsuneEvent.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/17.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

/// HatsuneEvent represents all the event areas like the first hatsune event, including normal and hard.
class HatsuneEvent: Codable {
  
    struct Base: Codable {
        let eventId: Int
        let startTime: String
        let title: String
    }
    
    let base: Base
    
    init(base: Base) {
        self.base = base
    }
    
    func preload() {
        _ = quests
        quests.forEach {
            $0.preload()
        }
    }
    
    lazy var quests: [HatsuneEventQuest] = DispatchSemaphore.sync { (closure) in
        return Master.shared.getHatsuneEventQuests(eventID: base.eventId, callback: closure)
    }?.filter { $0.difficultyType != .unknown } ?? []
    
    lazy var specialBattles: [HatsuneEventSpecialBattle] = DispatchSemaphore.sync { (closure) in
        return Master.shared.getHatsuneEventSpecialBattles(eventID: base.eventId, callback: closure)
    } ?? []
    
}

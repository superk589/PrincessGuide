//
//  ShioriEvent.swift
//  PrincessGuide
//
//  Created by zzk on 3/16/20.
//  Copyright © 2020 zzk. All rights reserved.
//

import Foundation

class ShioriEvent: NSObject {
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
    
    lazy var quests: [ShioriEventBossQuest] = DispatchSemaphore.sync { (closure) in
        return Master.shared.getShioriEventBossQuests(eventID: base.eventId, callback: closure)
        }?.filter { $0.difficultyType != .unknown } ?? []
    
}

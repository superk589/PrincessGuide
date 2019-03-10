//
//  ClanBattle.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation
import Timepiece

class ClanBattle: Codable {
    
    let period: Period
        
    struct Period: Codable {
        let clanBattleId: Int
        let period: Int
        let periodDetail: String
        let startTime: String
        let endTime: String
        let intervalStart: String
        let intervalEnd: String
        let calcStart: String
        let resultStart: String
        let resultEnd: String
    }
    
    class Round: Codable {
        
        struct Group: Codable {
            let wave: Wave
            let groupId: Int
            let orderNum: Int
            let scoreCoefficient: Double
        }
        
        let clanBattleBossGroupId: Int
        let lapNumFrom: Int
        var lapNumTo: Int
        
        func preload() {
            _ = groups
        }
        
        lazy var groups: [Group] = DispatchSemaphore.sync { (closure) in
            return Master.shared.getClanBattleRoundGroups(groupID: clanBattleBossGroupId, callback: closure)
        } ?? []
        
        var name: String {
            if lapNumFrom == lapNumTo {
                return String(format: NSLocalizedString("Round %d", comment: ""), lapNumFrom)
            } else if lapNumTo == -1 {
                return String(format: NSLocalizedString("Round %d+", comment: ""), lapNumFrom)
            } else {
                return String(format: NSLocalizedString("Round %d ~ %d", comment: ""), lapNumFrom, lapNumTo)
            }
        }
    }
    
    var name: String {
        let date = period.startTime.toDate()
        return String(format: NSLocalizedString("Clan Battle %d-%d", comment: ""), date.year, date.month)
    }
    
    lazy var rounds: [Round] = DispatchSemaphore.sync { (closure) in
        return Master.shared.getClanBattleRounds(clanBattleID: period.clanBattleId, callback: closure)
    } ?? []
    
    func preload() {
        _ = rounds
        rounds.forEach {
            $0.preload()
        }
    }
    
    lazy var mergedRounds: [Round] = {
        let newRounds: [Round] = rounds.reduce(into: []) { results, element in
            if let round = results.first(where: { $0.groups.map { $0.wave.base.waveGroupId } == element.groups.map { $0.wave.base.waveGroupId } }) {
                round.lapNumTo = element.lapNumTo
            } else {
                results.append(element)
            }
        }
        return newRounds
    }()
    
    init(period: Period) {
        self.period = period
    }

}
